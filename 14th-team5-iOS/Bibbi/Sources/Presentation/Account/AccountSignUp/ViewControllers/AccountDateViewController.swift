//
//  AccountDateViewController.swift
//  App
//
//  Created by geonhui Yu on 12/24/23.
//

import UIKit
import Core
import DesignSystem

import RxSwift
import Domain

fileprivate typealias _Str = AccountSignUpStrings.Date
final class AccountDateViewController: BaseViewController<AccountSignUpReactor> {
    private let titleLabel = BBLabel(.head2Bold, textColor: .gray300)
    
    private let yearInputFieldView = UITextField()
    private let yearLabel = UILabel()
    private let yearStackView = UIStackView()
    
    private let monthInputFieldView = UITextField()
    private let monthLabel = UILabel()
    private let monthStackView = UIStackView()
    
    private let dayInputFieldView = UITextField()
    private let dayLabel = UILabel()
    private let dayStackView = UIStackView()
    
    private let fieldStackView = UIStackView()
    
    private let errorLabel = BBLabel(.body1Regular, textColor: .warningRed)
    private let errorImage = UIImageView()
    private let errorStackView = UIStackView()
    
    private let nextButton = UIButton()
    private let descLabel = BBLabel(.body1Regular, textColor: .gray400)
    
    private let infoCircleFill = DesignSystemAsset.infoCircleFill.image
        .withRenderingMode(.alwaysTemplate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
    }
    
    // MARK: Bindings
    override func bind(reactor: AccountSignUpReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: AccountSignUpReactor) {
        let yearEditingChange = yearInputFieldView.rx
            .text.orEmpty
            .distinctUntilChanged()
            .filter { $0.count <= 4 }
            .map { Int($0) }
        
        yearEditingChange
            .map { Reactor.Action.setYear($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        yearEditingChange
            .withUnretained(self)
            .map { $0.0.moveToNextMonthField($0.1) }
            .filter { $0 }
            .withUnretained(self)
            .bind(onNext: { $0.0.monthInputFieldView.becomeFirstResponder() })
            .disposed(by: disposeBag)
        
        let monthEditingChange = monthInputFieldView.rx
            .text.orEmpty
            .distinctUntilChanged()
        
        monthEditingChange
            .map { Int($0) }
            .map { Reactor.Action.setMonth($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        monthEditingChange
            .filter { $0.count >= 2 }
            .withUnretained(self)
            .bind(onNext: { $0.0.dayInputFieldView.becomeFirstResponder() })
            .disposed(by: disposeBag)
        
        dayInputFieldView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Int($0) }
            .map { Reactor.Action.setDay($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
            .map { Reactor.Action.didTapDateNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: AccountSignUpReactor) {
        reactor.state.map { $0.nickname }
            .withUnretained(self)
            .observe(on: RxSchedulers.main)
            .bind(onNext: { $0.0.setTitleLabel(with: $0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isValidYear }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.validationYear($0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isValidMonth }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.validationMonth($0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isValidDay }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.validationDay($0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isValidDateButton }
            .withUnretained(self)
            .observe(on: RxSchedulers.main)
            .bind(onNext: { $0.0.validationButton($0.1) })
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        yearInputFieldView.rx.text.orEmpty
            .scan("") { $1.count > 4 ? $0 : $1 }
            .bind(to: yearInputFieldView.rx.text)
            .disposed(by: disposeBag)
        
        monthInputFieldView.rx.text.orEmpty
            .scan("") { $1.count > 2 ? $0 : $1 }
            .bind(to: monthInputFieldView.rx.text)
            .disposed(by: disposeBag)
        
        dayInputFieldView.rx.text.orEmpty
            .scan("") { $1.count > 2 ? $0 : $1 }
            .bind(to: dayInputFieldView.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        yearStackView.addArrangedSubviews(yearInputFieldView, yearLabel)
        monthStackView.addArrangedSubviews(monthInputFieldView, monthLabel)
        dayStackView.addArrangedSubviews(dayInputFieldView, dayLabel)
        
        fieldStackView.addArrangedSubviews(yearStackView, monthStackView, dayStackView)
        
        errorStackView.addArrangedSubviews(errorImage, errorLabel)
        view.addSubviews(titleLabel, fieldStackView, errorStackView, descLabel, nextButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(130)
        }
        
        fieldStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        errorStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(fieldStackView.snp.bottom).offset(12)
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
    
    override func setupAttributes() {
        super.setupAttributes()
    
        errorImage.do {
            $0.image = infoCircleFill.withTintColor(.warningRed)
            $0.contentMode = .scaleAspectFit
        }
        
        yearInputFieldView.do {
            $0.makePlaceholderAttributedString(_Str.yearPlaceholder, attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
            $0.keyboardType = .numberPad
        }
        
        yearLabel.do {
            $0.text = _Str.year
            $0.textColor = DesignSystemAsset.gray700.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
        }
        
        monthInputFieldView.do {
            $0.makePlaceholderAttributedString(_Str.monthPlaceholder, attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
            $0.keyboardType = .numberPad
        }
        
        monthLabel.do {
            $0.text = _Str.month
            $0.textColor = DesignSystemAsset.gray700.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
        }
        
        dayInputFieldView.do {
            $0.makePlaceholderAttributedString(_Str.dayPlaceholder, attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
            $0.keyboardType = .numberPad
        }
        
        dayLabel.do {
            $0.text = _Str.day
            $0.textColor = DesignSystemAsset.gray700.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
        }
        
        fieldStackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .fill
            $0.distribution = .fillProportionally
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

fileprivate extension AccountDateViewController {
    func validationYear(_ isValid: Bool) {
        errorStackView.isHidden = isValid
        yearInputFieldView.textColor = isValid ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
        yearLabel.textColor = isValid ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
    }
    
    func validationMonth(_ isValid: Bool) {
        errorStackView.isHidden = isValid
        monthInputFieldView.textColor = isValid ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
        monthLabel.textColor = isValid ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
    }
    
    func validationDay(_ isValid: Bool) {
        errorStackView.isHidden = isValid
        dayInputFieldView.textColor = isValid ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
        dayLabel.textColor = isValid ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
    }
    
    func validationButton(_ isValid: Bool) {
        let defaultColor = DesignSystemAsset.mainYellow.color
        nextButton.backgroundColor = isValid ? defaultColor : defaultColor.withAlphaComponent(0.2)
        nextButton.isEnabled = isValid
    }
    
    private func setTitleLabel(with nickname: String) {
        titleLabel.text = String(format: _Str.title, nickname)
    }
}

fileprivate extension AccountDateViewController {
    private func moveToNextMonthField(_ value: Int?) -> Bool {
        guard let value = value else {
            return false
        }
        return value >= 1900 ? true : false
    }
}
