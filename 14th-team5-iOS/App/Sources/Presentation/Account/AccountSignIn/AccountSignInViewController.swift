//
//  AccountSignInViewController.swift
//  App
//
//  Created by geonhui Yu on 12/18/23.
//

import UIKit
import Core

import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import Then

final class AccountSignInViewController: BaseViewController<AccountSignInReactor> {
    private enum Metric {
        
    }
    
    private let kakaoLoginButton = UIButton()
    private let appleLoginButton = UIButton()
    private let loginStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(loginStack)
        loginStack.addSubviews(kakaoLoginButton)
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        loginStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bind(reactor: AccountSignInReactor) {
        kakaoLoginButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.kakaoLoginTapped(.kakao, self) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.acceessToken }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.view.setNeedsLayout() })
            .disposed(by: disposeBag)
    }
}
