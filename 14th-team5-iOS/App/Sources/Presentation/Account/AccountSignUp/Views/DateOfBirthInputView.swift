//
//  DateOfBirthInputView.swift
//  App
//
//  Created by geonhui Yu on 12/8/23.
//

import UIKit
import Core

import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import Then

final class DateOfBirthInputView: BaseView<DateOfBirthReactor> {
    private enum Metric {}
    
    // MARK: SubViews
    private let titleLabel = UILabel()
    private let yearInputFielView = UITextField()
    private let yearLabel = UILabel()
    private let monthInputFielView = UITextField()
    private let monthLabel = UILabel()
    private let dayInputFielView = UITextField()
    private let dayLabel = UILabel()
    private let errorMessageLabel = UILabel()
    private let descLabel = UILabel()
    private let nextButton = UIButton()
    
    // MARK: LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Bindings
    override func bind(reactor: DateOfBirthReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: DateOfBirthReactor) {
        yearInputFielView.rx.text
            .distinctUntilChanged()
            .compactMap { $0.flatMap { Int($0) } }
            .map { Reactor.Action.setYear($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        monthInputFielView.rx.text
            .distinctUntilChanged()
            .compactMap { $0.flatMap { Int($0) } }
            .map { Reactor.Action.setYear($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dayInputFielView.rx.text
            .distinctUntilChanged()
            .compactMap { $0.flatMap { Int($0) } }
            .map { Reactor.Action.setYear($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: DateOfBirthReactor) {
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
        
    }
    
    override func setupAutoLayout() {
        
    }
    
    override func setupAttributes() {
        addSubviews(titleLabel, yearInputFielView, yearLabel, monthInputFielView, monthLabel, dayInputFielView, dayLabel, errorMessageLabel, descLabel, nextButton)
    }
}

fileprivate extension DateOfBirthInputView {
    func validationYear(_ isValid: Bool) {
        errorMessageLabel.isHidden = !isValid
        nextButton.isEnabled = isValid
        yearInputFielView.textColor = isValid ? .black : .red
        yearLabel.textColor = isValid ? .black : .red
    }
    
    func validationMonth(_ isValid: Bool) {
        errorMessageLabel.isHidden = !isValid
        nextButton.isEnabled = isValid
        monthInputFielView.textColor = isValid ? .black : .red
        monthLabel.textColor = isValid ? .black : .red
    }
    
    func validationDay(_ isValid: Bool) {
        errorMessageLabel.isHidden = !isValid
        nextButton.isEnabled = isValid
        dayInputFielView.textColor = isValid ? .black : .red
        dayLabel.textColor = isValid ? .black : .red
    }
}

fileprivate extension DateOfBirthInputView {
    private func setupTextFields() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .withUnretained(self)
            .bind(onNext: { $0.0.yearInputFielView.becomeFirstResponder() })
            .disposed(by: self.disposeBag)
        
        yearInputFielView.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind(onNext: { $0.0.monthInputFielView.becomeFirstResponder() })
            .disposed(by: disposeBag)
        
        monthInputFielView.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind(onNext: { $0.0.dayInputFielView.becomeFirstResponder() })
            .disposed(by: disposeBag)
    }
}
