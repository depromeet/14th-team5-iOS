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

final class AccountDateViewController: BaseViewController<AccountSignUpReactor> {
    // MARK: SubViews
    private let titleLabel = UILabel()
    
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
    
    private let errorLabel = UILabel()
    private let errorImage = UIImageView()
    private let errorStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Bindings
    override func bind(reactor: AccountSignUpReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: AccountSignUpReactor) {
        Observable
            .just(())
            .map { Reactor.Action.dateViewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
        
        let yearEditingChange = yearInputFieldView.rx
            .text.orEmpty
            .distinctUntilChanged()
            .filter { $0.count <= 4 }
            .compactMap { Int($0) }
        
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
        
        let monthEditingChange = monthInputFieldView.rx.text.orEmpty
            .distinctUntilChanged()
            .filter { $0.count <= 2 }
            .compactMap { Int($0) }
        
        monthEditingChange
            .map { Reactor.Action.setYear($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        monthEditingChange
            .withUnretained(self)
            .map { $0.0.moveToNextDayField($0.1) }
            .filter { $0 }
            .withUnretained(self)
            .bind(onNext: { $0.0.dayInputFieldView.becomeFirstResponder() })
            .disposed(by: disposeBag)
        
        dayInputFieldView.rx.text
            .distinctUntilChanged()
            .compactMap { $0.flatMap { Int($0) } }
            .map { Reactor.Action.setYear($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: AccountSignUpReactor) {
        reactor.state.map { $0.nickname }
            .withUnretained(self)
            .observe(on: Schedulers.main)
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
    }
    
    override func setupUI() {
        super.setupUI()
        
        yearStackView.addArrangedSubviews(yearInputFieldView, yearLabel)
        monthStackView.addArrangedSubviews(monthInputFieldView, monthLabel)
        dayStackView.addArrangedSubviews(dayInputFieldView, dayLabel)
        
        fieldStackView.addArrangedSubviews(yearStackView, monthStackView, dayStackView)
        
        errorStackView.addArrangedSubviews(errorImage, errorLabel)
        view.addSubviews(titleLabel, fieldStackView, errorStackView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(190)
        }
        
        fieldStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        errorStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview().inset(20)
            $0.top.equalTo(fieldStackView.snp.bottom).offset(12)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        titleLabel.do {
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 18)
            $0.textColor = DesignSystemAsset.gray300.color
        }
        
        errorImage.do {
            $0.contentMode = .scaleAspectFit
            $0.image = DesignSystemAsset.infoCircleFill.image
        }
        
        yearInputFieldView.do {
            $0.makePlaceholderAttributedString("0000", attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
            $0.keyboardType = .numberPad
        }
        
        yearLabel.do {
            $0.text = "년"
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
        }
        
        monthInputFieldView.do {
            $0.makePlaceholderAttributedString("0", attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
            $0.keyboardType = .numberPad
        }
        
        monthLabel.do {
            $0.text = "월"
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
        }
        
        dayInputFieldView.do {
            $0.makePlaceholderAttributedString("0", attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
            $0.keyboardType = .numberPad
        }
        
        dayLabel.do {
            $0.text = "일"
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
        }
        
        fieldStackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        errorLabel.do {
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.regular, size: 16)
            $0.textColor = DesignSystemAsset.warningRed.color
            $0.text = "올바른 날짜를 입력해주세요"
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
    
    private func setTitleLabel(with nickname: String) {
        titleLabel.text = "안녕하세요 \(nickname)님, 생일이 언제신가요?"
    }
}

fileprivate extension AccountDateViewController {
    private func moveToNextMonthField(_ value: Int) -> Bool {
        value >= 1000 ? true : false
    }
    
    private func moveToNextDayField(_ value: Int) -> Bool {
        value >= 10 ? true : false
    }
}
