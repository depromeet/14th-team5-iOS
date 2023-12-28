//
//  AccountSignInViewController.swift
//  App
//
//  Created by geonhui Yu on 12/18/23.
//

import UIKit
import Core
import DesignSystem

import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import Then

public final class AccountSignInViewController: BaseViewController<AccountSignInReactor> {
    private let kakaoLoginButton = UIButton()
    private let appleLoginButton = UIButton()
    private let loginStack = UIStackView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override public func setupUI() {
        super.setupUI()
        
        loginStack.addArrangedSubviews(kakaoLoginButton, appleLoginButton)
        view.addSubviews(loginStack)
    }
    
    override public func setupAttributes() {
        super.setupAttributes()
        
        loginStack.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        kakaoLoginButton.do {
            $0.setImage(DesignSystemAsset.kakaoLogin.image, for: .normal)
        }
        
        appleLoginButton.do {
            $0.setImage(DesignSystemAsset.appleLogin.image, for: .normal)
        }
    }
    
    override public func setupAutoLayout() {
        super.setupAutoLayout()
        
        loginStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override public func bind(reactor: AccountSignInReactor) {
        kakaoLoginButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.kakaoLoginTapped(.kakao, self) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.kakaoLoginTapped(.apple, self) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pushAccountSingUpVC }
            .filter { $0 }
            .observe(on: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: { $0.0.pushAccountSignUpViewController() })
            .disposed(by: disposeBag)
    }
}

extension AccountSignInViewController {
    func pushAccountSignUpViewController() {
        let container = AccountSignUpDIContainer().makeViewController()
        container.modalPresentationStyle = .fullScreen
        present(container, animated: true)
    }
}

extension AccountSignInViewController {
    func pushCalendarFeedView(_ date: Date?) {
        let container = AccountSignUpDIContainer()
        navigationController?.pushViewController(container.makeViewController(), animated: true)
    }
}
