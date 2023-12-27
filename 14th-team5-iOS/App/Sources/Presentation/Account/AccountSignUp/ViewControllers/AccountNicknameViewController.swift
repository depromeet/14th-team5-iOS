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

final class AccountNicknameViewController: BaseViewController<AccountSignUpReactor> {
    private enum Metric {
        static let titleAfter: CGFloat = 5
        static let inputFieldAfter: CGFloat = 5
        static let descAfter: CGFloat = 5
    }
    
    // MARK: SubViews
    private let titleLabel = UILabel()
    private let inputFielView = UITextField()
    private let errorLabel = UILabel()
    private let errorImage = UIImageView()
    private let errorStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind(reactor: AccountSignUpReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: AccountSignUpReactor) {
        inputFielView.rx.text
            .distinctUntilChanged()
            .map { $0 ?? "" }
            .map { Reactor.Action.setNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inputFielView.rx.text.orEmpty
            .scan("") { $1.count > 10 ? $0 : $1 }
            .bind(to: inputFielView.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: AccountSignUpReactor) {
        reactor.state.map { $0.isValidNickname }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.validationNickname($0.1) })
            .disposed(by: self.disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(titleLabel, inputFielView, errorStackView)
        errorStackView.addArrangedSubviews(errorImage, errorLabel)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(190)
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(190)
        }
        
        inputFielView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        errorStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(inputFielView.snp.bottom).offset(12)
        }
    }
    
    override func setupAttributes() {
        titleLabel.do {
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 18)
            $0.textColor = DesignSystemAsset.gray300.color
            $0.text = "닉네임을 입력해주세요"
        }
        
        inputFielView.do {
            $0.makePlaceholderAttributedString("김아빠", attributed: [
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
            $0.text = "10자 이내로 입력해주세요"
        }
        
        errorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .fill
            $0.distribution = .fillProportionally
            $0.isHidden = true
        }
    }
}

extension AccountNicknameViewController {
    fileprivate func validationNickname(_ isValid: Bool) {
        errorStackView.isHidden = isValid
        inputFielView.textColor = isValid ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
    }
}
