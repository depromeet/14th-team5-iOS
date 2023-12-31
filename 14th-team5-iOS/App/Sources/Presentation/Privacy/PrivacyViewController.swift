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
    private let titleView: TypeSystemLabel = TypeSystemLabel(.head2Bold, textColor: .gray200)
    private let backButton: UIButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 52, height: 52)))
    private let privacyTableView: UITableView = UITableView(frame: .zero, style: .grouped)
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
    
    //MARK: Configure
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(privacyTableView, privacyIndicatorView)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        titleView.do {
            $0.text = "설정 및 개인정보"
        }
        
        backButton.do {
            $0.setImage(DesignSystemAsset.arrowLeft.image, for: .normal)
            $0.backgroundColor = DesignSystemAsset.gray900.color
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        
        navigationItem.do {
            $0.titleView = titleView
            $0.leftBarButtonItem = UIBarButtonItem(customView: backButton)
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
        privacyTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        privacyIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    public override func bind(reactor: PrivacyViewReactor) {
        privacyTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        backButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController(animated: true)
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
