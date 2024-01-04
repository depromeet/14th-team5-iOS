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
        static let bibbiInset: CGFloat = 100
        static let titleOffset: CGFloat = 26
        static let imageSpacing: CGFloat = -10
        static let imageInset: CGFloat = 60
        static let imageOffset: CGFloat = 50
        static let loginOffset: CGFloat = -10
        
        static let spacing: CGFloat = 12
        static let inset: CGFloat = 16
    }
    
    private let bibbiImageView = UIImageView()
    private let mainTitleLabel = BibbiLabel(.head2Bold, alignment: .center, textColor: .gray100)
    
    private let imageStack = UIStackView()
    private let palmTreeImageView = UIImageView()
    private let beeperImageView = UIImageView()
    
    private let kakaoLoginButton = UIButton()
    private let appleLoginButton = UIButton()
    private let loginStack = UIStackView()
    
    override public func setupUI() {
        super.setupUI()
        imageStack.addArrangedSubviews(palmTreeImageView, beeperImageView)
        view.addSubviews(bibbiImageView, mainTitleLabel, imageStack)
        
        loginStack.addArrangedSubviews(kakaoLoginButton, appleLoginButton)
        view.addSubviews(loginStack)
    }
    
    override public func setupAttributes() {
        super.setupAttributes()
        
        bibbiImageView.do {
            $0.image = DesignSystemAsset.newBibbi.image
            $0.contentMode = .scaleAspectFill
        }
        
        mainTitleLabel.do {
            $0.text = AccountSignInStrings.mainTitle
        }
        
        imageStack.do {
            $0.axis = .horizontal
            $0.spacing = Metric.imageSpacing
            $0.alignment = .center
            $0.distribution = .fillProportionally
        }
        
        palmTreeImageView.do {
            $0.image = DesignSystemAsset.palmTree.image
            $0.contentMode = .scaleAspectFill
        }
        
        beeperImageView.do {
            $0.image = DesignSystemAsset.beeper.image
            $0.contentMode = .scaleAspectFill
            $0.transform = CGAffineTransform(translationX: 0, y: 32)
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
            $0.horizontalEdges.equalToSuperview().inset(Metric.bibbiInset)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bibbiImageView.snp.bottom).offset(Metric.titleOffset)
            $0.centerX.equalToSuperview()
        }
        
        imageStack.snp.makeConstraints {
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
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.kakaoLoginTapped(.kakao, self) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.appleLoginTapped(.apple, self) }
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
        let container = UINavigationController(rootViewController: AccountSignUpDIContainer().makeViewController())
        container.modalPresentationStyle = .fullScreen
        present(container, animated: true)
    }
}
