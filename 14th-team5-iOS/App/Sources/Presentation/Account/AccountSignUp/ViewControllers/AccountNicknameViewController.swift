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
final class AccountNicknameViewController: BaseViewController<AccountSignUpReactor> {
    private enum Metric {}
    
    // MARK: SubViews
    private let titleLabel = UILabel()
    private let inputFielView = UITextField()
    private let errorLabel = UILabel()
    private let errorImage = UIImageView()
    private let errorStackView = UIStackView()
    private let nextButton = UIButton()
    private let descLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind(reactor: AccountSignUpReactor) {
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
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.nicknameButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: AccountSignUpReactor) {
        reactor.state.map { $0.isValidNickname }
            .withUnretained(self)
            .observe(on: Schedulers.main)
            .bind(onNext: { $0.0.validationNickname($0.1) })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isValidButton }
            .withUnretained(self)
            .observe(on: Schedulers.main)
            .bind(onNext: { $0.0.validationButton($0.1) })
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(titleLabel, inputFielView, errorStackView, descLabel, nextButton)
        errorStackView.addArrangedSubviews(errorImage, errorLabel)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(190)
        }
        
        inputFielView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        errorStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(inputFielView.snp.bottom).offset(12)
        }
        
        descLabel.do {
            $0.text = _Str.desc
            $0.textColor = DesignSystemAsset.gray400.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.regular, size: 16)
        }
        
        nextButton.do {
            $0.setTitle("계속", for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.mainGreen.color.withAlphaComponent(0.2)
            $0.isEnabled = false
            $0.layer.cornerRadius = 30
        }
    }
    
    override func setupAttributes() {
        titleLabel.do {
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 18)
            $0.textColor = DesignSystemAsset.gray300.color
            $0.text = _Str.title
        }
        
        inputFielView.do {
            $0.makePlaceholderAttributedString(_Str.placeholder, attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
        }
        
        errorImage.do {
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = DesignSystemAsset.warningRed.color
            $0.image = DesignSystemAsset.infoCircleFill.image
        }
        
        errorLabel.do {
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.regular, size: 16)
            $0.textColor = DesignSystemAsset.warningRed.color
            $0.text = _Str.errorMsg
        }
        
        errorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .fill
            $0.distribution = .fillProportionally
            $0.isHidden = true
        }
        
        descLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            $0.height.equalTo(56)
        }
    }
}

extension AccountNicknameViewController {
    fileprivate func validationNickname(_ isValid: Bool) {
        errorStackView.isHidden = isValid
        inputFielView.textColor = isValid ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
    }
    
    fileprivate func validationButton(_ isValid: Bool) {
        let defaultColor = DesignSystemAsset.mainGreen.color
        nextButton.backgroundColor = isValid ? defaultColor : defaultColor.withAlphaComponent(0.2)
        nextButton.isEnabled = isValid
    }
}
