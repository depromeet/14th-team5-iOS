//
//  SplashViewController.swift
//  App
//
//  Created by 김건우 on 1/4/24.
//

import UIKit
import Core
import DesignSystem
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then

public final class SplashViewController: BaseViewController<SplashViewReactor> {
    // MARK: - Mertic
    private enum Metric {
        static let bibbiOffset: CGFloat = 80
        static let bibbiHeight: CGFloat = 70
        static let titleOffset: CGFloat = 26
    }
    
    // MARK: - Views
    private let bibbiImageView = UIImageView()
    private let mainTitleLabel = BibbiLabel(.head2Bold, alignment: .center, textColor: .gray100)
    
    private let iconsImageView = UIImageView()
    
    // MARK: - LifeCycles
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Helpers
    override public func setupUI() {
        super.setupUI()
        view.addSubviews(bibbiImageView, mainTitleLabel, iconsImageView)
    }
    
    override public func setupAttributes() {
        super.setupAttributes()
        
        bibbiImageView.do {
            $0.image = DesignSystemAsset.newBibbi.image
            $0.contentMode = .scaleAspectFit
        }
        
        mainTitleLabel.do {
            $0.text = AccountSignInStrings.mainTitle
            $0.textColor = .gray100
            $0.font = UIFont.pretendard(.head2Bold)
        }
        
        iconsImageView.do {
            $0.image = DesignSystemAsset.splashIcons.image
            $0.contentMode = .scaleAspectFit
        }
    }
    
    override public func setupAutoLayout() {
        super.setupAutoLayout()
        
        bibbiImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Metric.bibbiOffset)
            $0.height.equalTo(Metric.bibbiHeight)
            $0.horizontalEdges.equalToSuperview()
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bibbiImageView.snp.bottom).offset(Metric.titleOffset)
            $0.centerX.equalToSuperview()
        }
        
        iconsImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
            $0.height.equalTo(iconsImageView.snp.width).multipliedBy(0.8)
        }
    }
    
    override public func bind(reactor: SplashViewReactor) {
        Observable.just(())
            .take(1)
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.memberInfo }
            .skip(1)
            .withUnretained(self)
            .observe(on: Schedulers.main)
            .bind(onNext: { $0.0.showNextPage(with: $0.1) })
            .disposed(by: disposeBag)
    }
    
    private func showNextPage(with member: MemberInfo?) {
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        let container: UINavigationController
        
        if let _ = member?.familyId {
            var container: UINavigationController
            if UserDefaults.standard.finishTutorial {
                container = UINavigationController(rootViewController: HomeDIContainer().makeViewController())
            } else {
                container = UINavigationController(rootViewController: OnBoardingDIContainer().makeViewController())
            }
            sceneDelegate.window?.rootViewController = container
            sceneDelegate.window?.makeKeyAndVisible()
            return
        }
        
        guard let isTemporary = App.Repository.token.accessToken.value?.isTemporaryToken else {
            container = UINavigationController(rootViewController: AccountSignInDIContainer().makeViewController())
            sceneDelegate.window?.rootViewController = container
            sceneDelegate.window?.makeKeyAndVisible()
            return
        }
        
        if isTemporary {
            container = UINavigationController(rootViewController: AccountSignUpDIContainer().makeViewController())
            sceneDelegate.window?.rootViewController = container
            sceneDelegate.window?.makeKeyAndVisible()
            return
        } else {
            container = UINavigationController(rootViewController: OnBoardingDIContainer().makeViewController())
        }
        
        sceneDelegate.window?.rootViewController = container
        sceneDelegate.window?.makeKeyAndVisible()
    }
}
