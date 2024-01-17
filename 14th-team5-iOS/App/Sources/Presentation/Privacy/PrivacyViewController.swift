//
//  PrivacyViewController.swift
//  App
//
//  Created by Kim dohyun on 12/15/23.
//

import UIKit

import Core
import DesignSystem
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
import SnapKit
import Then

public final class PrivacyViewController: BaseViewController<PrivacyViewReactor> {
    //MARK: Views
    private let privacyTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    private let privacyNavigationBar: BibbiNavigationBarView = BibbiNavigationBarView()
    private let privacyIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let privacyTableViewDataSources: RxTableViewSectionedReloadDataSource<PrivacySectionModel> = .init { dataSoruces, tableView, indexPath, sectionItem in
        switch sectionItem {
        case let .privacyWithAuthItem(cellReactor):
            guard let privacyCell = tableView.dequeueReusableCell(withIdentifier: "PrivacyTableViewCell", for: indexPath) as? PrivacyTableViewCell else { return UITableViewCell() }
            privacyCell.reactor = cellReactor
            return privacyCell
        case let .userAuthorizationItem(cellReactor):
            guard let authorizationCell = tableView.dequeueReusableCell(withIdentifier: "PrivacyAuthorizationTableViewCell", for: indexPath) as? PrivacyAuthorizationTableViewCell else { return UITableViewCell() }
            authorizationCell.reactor = cellReactor
            
            return authorizationCell
        }
    }
    
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: Configure
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(privacyTableView, privacyIndicatorView, privacyNavigationBar)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        privacyNavigationBar.do {
            $0.navigationTitle = "설정 및 개인정보"
            $0.leftBarButtonItem = .arrowLeft
            $0.leftBarButtonItemTintColor = .gray300
        }
        
        
        privacyTableView.do {
            $0.backgroundColor = DesignSystemAsset.black.color
            $0.separatorStyle = .none
            $0.register(PrivacyTableViewCell.self, forCellReuseIdentifier: "PrivacyTableViewCell")
            $0.register(PrivacyAuthorizationTableViewCell.self, forCellReuseIdentifier: "PrivacyAuthorizationTableViewCell")
            $0.register(PrivacyHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "PrivacyHeaderFooterView")
            $0.register(PrivacyAuthorizationHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "PrivacyAuthorizationHeaderFooterView")
            $0.rowHeight = 44
        }
        
        privacyIndicatorView.do {
            $0.color = .gray
            $0.hidesWhenStopped = true
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        privacyNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        privacyTableView.snp.makeConstraints {
            $0.top.equalTo(privacyNavigationBar.snp.bottom).offset(24)
            $0.left.bottom.right.equalToSuperview()
            
        }
        
        privacyIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    public override func bind(reactor: PrivacyViewReactor) {
        privacyTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default
            .rx.notification(.AppVersionsCheckWithRedirectStore)
            .withLatestFrom(reactor.state.compactMap { $0.appInfo?.latest})
            .filter { $0 == true }
            .bind { _ in
                UIApplication.shared.open(URLTypes.appStore("362057947").originURL)
            }.disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.isSuccess }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isSuccess in
                guard isSuccess else { return }
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.window?.rootViewController = AccountSignInDIContainer().makeViewController()
                sceneDelegate.window?.makeKeyAndVisible()
            }.disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(.UserAccountLogout)
            .map { _ in Reactor.Action.didTapLogoutButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(.UserFamilyResign)
            .map { _ in Reactor.Action.didTapFamilyUserResign }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        privacyNavigationBar.rx
            .didTapLeftBarButton
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        privacyTableView.rx
            .itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                switch owner.privacyTableViewDataSources[indexPath] {
                case .privacyWithAuthItem:
                    if indexPath.item == 0 {
                        NotificationCenter.default.post(name: .AppVersionsCheckWithRedirectStore, object: nil, userInfo: nil)
                    } else if indexPath.item == 1 {
                        UIApplication.shared.open(URLTypes.settings.originURL)
                    } else {
                        let webContentViewController = WebContentDIContainer().makeViewController()
                        owner.navigationController?.pushViewController(webContentViewController, animated: true)
                    }
                case .userAuthorizationItem:
                    if indexPath.item == 0 {
                        owner.showLogoutAlertController()
                    } else if indexPath.item == 1 {
                        owner.showFamilyResignAlertController()
                    } else {
                        let resignViewController = AccountResignDIContainer().makeViewController()
                        owner.navigationController?.pushViewController(resignViewController, animated: true)
                    }
                }
            }.disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
            .drive(privacyIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$section)
            .asDriver(onErrorJustReturn: [])
            .drive(privacyTableView.rx.items(dataSource: privacyTableViewDataSources))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isFamilyResign }
            .filter { $0 == true }
            .subscribe { _ in
                App.Repository.member.familyId.accept(nil)
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.window?.rootViewController = JoinFamilyDIContainer().makeViewController()
                sceneDelegate.window?.makeKeyAndVisible()
            }.disposed(by: disposeBag)
        
    }
    
}


extension PrivacyViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch privacyTableViewDataSources[section] {
        case .privacyWithAuth:
            guard let privacyHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PrivacyHeaderFooterView") as? PrivacyHeaderFooterView else { return UITableViewHeaderFooterView() }
            return privacyHeaderView
        case .userAuthorization:
            guard let authorizationHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PrivacyAuthorizationHeaderFooterView") as? PrivacyAuthorizationHeaderFooterView else { return UITableViewHeaderFooterView() }
            return authorizationHeaderView
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


extension PrivacyViewController {
    
    private func showLogoutAlertController() {
        let logoutAlertController = UIAlertController(
            title: "로그 아웃",
            message: "로그 아웃 하시겠어요?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            NotificationCenter.default.post(name: .UserAccountLogout, object: nil, userInfo: nil)
        }
        
        [cancelAction, confirmAction].forEach(logoutAlertController.addAction(_:))
        logoutAlertController.overrideUserInterfaceStyle = .dark
        present(logoutAlertController, animated: true)
    }
    
    private func showFamilyResignAlertController() {
        let resignAlertController = UIAlertController(
            title: "그룹 탈퇴",
            message: "그룹을 탈퇴해도 나의 활동 내역은\n유지되니 참고해주세요.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            NotificationCenter.default.post(name: .UserFamilyResign, object: nil, userInfo: nil)
        }
        
        [cancelAction, confirmAction].forEach(resignAlertController.addAction(_:))
        
        resignAlertController.overrideUserInterfaceStyle = .dark
        present(resignAlertController, animated: true)
        
    }
    
}
