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
        
        view.addSubviews(appleLoginButton, kakaoLoginButton)
    }
    
    override public func setupAttributes() {
        super.setupAttributes()
        
//        kakaoLoginButton.do {
//            $0.setImage(DesignSystemAsset.kakaoLogin.image, for: .normal)
//        }
        
        appleLoginButton.do {
            $0.setImage(DesignSystemAsset.appleLogin.image, for: .normal)
        }
    }
    
    override public func setupAutoLayout() {
        super.setupAutoLayout()
        
//        kakaoLoginButton.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview().inset(16)
//            $0.height.equalTo(56)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
        
        appleLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
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
        
//        reactor.state.map { $0.acceessToken }
//            .filter { $0.isEmpty }
//            .distinctUntilChanged()
//            .withUnretained(self)
//            .bind(onNext: { _ in print("다음화면 이동하자!") })
//            .disposed(by: disposeBag)
    }
}
