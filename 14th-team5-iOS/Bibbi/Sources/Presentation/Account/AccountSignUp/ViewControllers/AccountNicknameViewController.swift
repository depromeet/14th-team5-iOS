//
//  AccountNicknameViewController.swift
//  App
//
//  Created by geonhui Yu on 12/24/23.
//

import UIKit
import Core
import DesignSystem

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import Then

fileprivate typealias _Str = AccountSignUpStrings.Nickname
public final class AccountNicknameViewController: BaseViewController<AccountSignUpReactor> {
    // MARK: SubViews
    private let titleLabel = BBLabel(.head2Bold, textColor: .gray300)
    private let inputFielView = UITextField()
    private let errorLabel = BBLabel(.body1Regular, textColor: .warningRed)
    private let errorImage = UIImageView()
    private let errorStackView = UIStackView()
    private let nextButton = UIButton()
    private let descLabel = BBLabel(.body1Regular, textColor: .gray400)
    
    private let infoCircleFill = DesignSystemAsset.infoCircleFill.image
        .withRenderingMode(.alwaysTemplate)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = DesignSystemAsset.black.color
    }
    
    public override func bind(reactor: AccountSignUpReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: AccountSignUpReactor) {
        inputFielView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.setNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inputFielView.rx.text.orEmpty
            .scan("") { $1.count > 10 ? $0 : $1 }
            .bind(to: inputFielView.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
            .map { Reactor.Action.didTapNicknameNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        Observable
            .zip(
                reactor.state.map { $0.profileType }.distinctUntilChanged(),
                nextButton.rx.tap.asObservable()
            ).filter { $0.0 == .profile }
            .withLatestFrom(inputFielView.rx.text.orEmpty.distinctUntilChanged())
            .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
            .map { Reactor.Action.didTapNickNameButton($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: AccountSignUpReactor) {
        reactor.state.map { $0.isValidNickname }
            .withUnretained(self)
            .observe(on: RxSchedulers.main)
            .bind(onNext: { $0.0.validationNickname($0.1) })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isValidNicknameButton }
            .withUnretained(self)
            .observe(on: RxSchedulers.main)
            .bind(onNext: { $0.0.validationButton($0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profileNickNameEditEntity }
            .filter { $0 != nil }
            .withUnretained(self)
            .bind(onNext: { $0.0.transitionProfileViewController()})
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profileType }
            .filter { $0 == .profile }
            .map { _ in "완료"}
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profileType }
            .take(1)
            .filter { $0 == .account }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.navigationBarView.isHidden = true  })
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        view.addSubviews(titleLabel, inputFielView, errorStackView, descLabel, nextButton)
        errorStackView.addArrangedSubviews(errorImage, errorLabel)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(130)
        }
        
        inputFielView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        errorStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(inputFielView.snp.bottom).offset(12)
        }
        
        descLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-14)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            $0.height.equalTo(56)
        }
    }
    
    public override func setupAttributes() {
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, centerItem: .label("닉네임 변경"), rightItem: .empty)
        }
        
        titleLabel.do {
            $0.text = _Str.title
        }
        
        inputFielView.do {
            $0.makePlaceholderAttributedString(_Str.placeholder, attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
        
        errorImage.do {
            $0.image = infoCircleFill.withTintColor(.warningRed)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = DesignSystemAsset.warningRed.color
        }
        
        errorLabel.do {
            $0.text = _Str.errorMsg
        }
        
        errorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .fill
            $0.distribution = .fillProportionally
            $0.isHidden = true
        }
        
        descLabel.do {
            $0.text = _Str.desc
        }
        
        nextButton.do {
            $0.setTitle("계속", for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.mainYellow.color.withAlphaComponent(0.2)
            $0.isEnabled = false
            $0.layer.cornerRadius = 28
        }
    }
}

extension AccountNicknameViewController {
    fileprivate func validationNickname(_ isValid: Bool) {
        errorStackView.isHidden = isValid
        inputFielView.textColor = isValid ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
    }
    
    fileprivate func validationButton(_ isValid: Bool) {
        let defaultColor = DesignSystemAsset.mainYellow.color
        nextButton.backgroundColor = isValid ? defaultColor : defaultColor.withAlphaComponent(0.2)
        nextButton.isEnabled = isValid
    }
    
    fileprivate func transitionProfileViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
