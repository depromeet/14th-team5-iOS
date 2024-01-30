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
    // MARK: - Views
    private let bibbiImageView = UIImageView()
    
    // MARK: - LifeCycles
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = DesignSystemAsset.mainYellow.color
    }
    
    // MARK: - Helpers
    override public func setupUI() {
        super.setupUI()
        
        view.addSubviews(bibbiImageView)
    }
    
    override public func setupAttributes() {
        super.setupAttributes()
        
        bibbiImageView.do {
            $0.image = UIImage(named: "splash")
            $0.contentMode = .scaleAspectFit
        }
    }
    
    override public func setupAutoLayout() {
        super.setupAutoLayout()
        
        bibbiImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
            .delay(.milliseconds(500), scheduler: Schedulers.main)
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
