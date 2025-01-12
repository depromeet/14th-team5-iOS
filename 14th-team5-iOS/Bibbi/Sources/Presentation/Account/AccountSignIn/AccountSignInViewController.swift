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
    
    private let kakaoLoginButton = BBButton()
    private let appleLoginButton = BBButton()
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
            $0.distribution = .fillEqually
        }
        
        kakaoLoginButton.do {
            $0.setImage(DesignSystemAsset.kakao.image)
            $0.setTitle("Kakao로 계속하기", for: .normal)
            $0.backgroundColor = UIColor(red: 254/255, green: 229/255, blue: 0/255, alpha: 1)
            $0.layer.cornerRadius = 8
            $0.setTitleColor(.bibbiBlack, for: .normal)
            $0.setTitleFontStyle(.head2Bold)
        }
        
        appleLoginButton.do {
            $0.setImage(DesignSystemAsset.apple.image)
            $0.setTitle("Apple로 계속하기", for: .normal)
            $0.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
            $0.layer.cornerRadius = 8
            $0.setTitleColor(.bibbiBlack, for: .normal)
            $0.setTitleFontStyle(.head2Bold)
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
            $0.height.equalTo(124)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
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
    }
}

