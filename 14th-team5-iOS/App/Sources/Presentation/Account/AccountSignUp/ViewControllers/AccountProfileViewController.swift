//
//  AccountProfileViewController.swift
//  App
//
//  Created by geonhui Yu on 12/24/23.
//

import UIKit
import Core
import DesignSystem
import Domain
import PhotosUI

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import Then

fileprivate typealias _Str = AccountSignUpStrings.Profile
final class AccountProfileViewController: BaseViewController<AccountSignUpReactor> {
    // MARK: SubViews
    private let titleLabel = UILabel()
    private let profileButton = UIButton()
    
    private let nextButton = UIButton()
    private let profileView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind(reactor: AccountSignUpReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: AccountSignUpReactor) {
        nextButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.didTapCompletehButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.profileImageTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.AccountViewPresignURLDismissNotification)
            .compactMap { notification -> String? in
                guard let userInfo = notification.userInfo else { return nil }
                return userInfo["presignedURL"] as? String
            }
            .map { Reactor.Action.profilePresignedURL($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: AccountSignUpReactor) {
        reactor.state.map { $0.nickname }
            .withUnretained(self)
            .observe(on: Schedulers.main)
            .bind(onNext: { $0.0.setProfilewView(with: $0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.didTapCompletehButtonFinish }
            .withUnretained(self)
            .observe(on: Schedulers.main)
            .bind(onNext: { $0.0.showNextPage(accessToken: $0.1) })
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(titleLabel, profileButton, nextButton, profileView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(190)
        }
        
        profileButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.width.height.equalTo(90)
        }
        
        profileView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.width.height.equalTo(90)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            $0.height.equalTo(56)
        }
    }
    
    override func setupAttributes() {
        titleLabel.do {
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 18)
            $0.textColor = DesignSystemAsset.gray300.color
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        
        profileButton.do {
            $0.tintColor = DesignSystemAsset.gray200.color
            $0.backgroundColor = DesignSystemAsset.gray800.color
            $0.layer.cornerRadius = 45
        }
        
        nextButton.do {
            $0.setTitle(_Str.buttonTitle, for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.mainGreen.color
            $0.layer.cornerRadius = 30
        }
        
    }
}

extension AccountProfileViewController {
    private func setProfilewView(with nickname: String) {
        let profileImageData = profileButton.asImage().jpegData(compressionQuality: 1.0)
        UserDefaults.standard.profileImage = profileImageData
        print("profileButto test: \(profileImageData)")
        titleLabel.text = String(format: _Str.title, nickname)
        
        if let firstName = nickname.first {
            profileButton.setTitle(String(firstName), for: .normal)
        }
    }
    
    private func showNextPage(accessToken: AccessTokenResponse?) {
        
        guard let accessToken = accessToken else { return }
        
        let token = accessToken.accessToken
        let refreshToken = accessToken.refreshToken
        let isTemporaryToken = accessToken.isTemporaryToken
        
        let tk = AccessToken(accessToken: token, refreshToken: refreshToken, isTemporaryToken: isTemporaryToken)
        App.Repository.token.accessToken.accept(tk)
        
        let container = UINavigationController(rootViewController: OnBoardingDIContainer().makeViewController())
        container.modalPresentationStyle = .fullScreen
        present(container, animated: false)
    }
}
