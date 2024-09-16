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
    private enum Metric {
        static let bibbiOffset: CGFloat = 36
        static let bibbiHeight: CGFloat = 70
        static let titleOffset: CGFloat = 26
        static let imageInset: CGFloat = 60
        static let imageOffset: CGFloat = 55
        static let loginOffset: CGFloat = -10
        
        static let spacing: CGFloat = 12
        static let inset: CGFloat = 20
    }
    
    private let bibbiImageView = UIImageView()
    private let titleLabel = BBLabel(.body1Bold, textAlignment: .center, textColor: .gray200)
    private let loginImageView = UIImageView()
    
    private let kakaoLoginButton = UIButton()
    private let appleLoginButton = UIButton()
    private let loginStack = UIStackView()
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override public func setupUI() {
        super.setupUI()
        
        view.addSubviews(bibbiImageView, titleLabel, loginImageView)
        
        loginStack.addArrangedSubviews(kakaoLoginButton, appleLoginButton)
        view.addSubviews(loginStack)
    }
    
    override public func setupAttributes() {
        super.setupAttributes()
        
        bibbiImageView.do {
            $0.image = DesignSystemAsset.bibbiLogo.image
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.text = AccountSignInStrings.mainTitle
        }
        
        loginImageView.do {
            $0.image = DesignSystemAsset.loginCharacter.image
            $0.contentMode = .scaleAspectFill
        }
        
        loginStack.do {
            $0.axis = .vertical
            $0.spacing = Metric.spacing
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
        
        bibbiImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Metric.bibbiOffset)
            $0.height.equalTo(Metric.bibbiHeight)
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bibbiImageView.snp.bottom).offset(Metric.titleOffset)
            $0.centerX.equalToSuperview()
        }
        
        loginImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Metric.imageInset)
            $0.centerY.equalToSuperview().offset(Metric.imageOffset)
        }
        
        loginStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Metric.inset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(Metric.loginOffset)
        }
    }
    
    override public func bind(reactor: AccountSignInReactor) {
        kakaoLoginButton.rx.tap
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.kakaoLoginTapped(.kakao, self) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.appleLoginTapped(.apple, self) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        Observable
            .combineLatest(
                App.Repository.token.accessToken.distinctUntilChanged(),
                reactor.pulse(\.$isFirstOnboarding).distinctUntilChanged()
            )
            .skip(1)
            .observe(on: RxScheduler.main)
            .bind(with: self) { owner, response in
                let (token, isFirstOnboarding) = response
                owner.showNextPage(token: token, isFirstOnboarding)
            }
            .disposed(by: disposeBag)
    }
}

extension AccountSignInViewController {
    private func showNextPage(token: AccessToken?, _ isFirstOnboarding: Bool) {
        @Navigator var signInNavigator: AccountSignInNavigatorProtocol
        guard let token = token, let isTemporaryToken = token.isTemporaryToken else { return }
        if isTemporaryToken {
            signInNavigator.toSignUp()
            return
        }
        
        if isFirstOnboarding {
            signInNavigator.toMain()
            return
        }
    }
}
