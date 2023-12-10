//
//  NicknameInputView.swift
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

final class NicknameInputView: BaseView<NicknameInputReactor> {
    private enum Metric {
        static let titleAfter: CGFloat = 5
        static let inputFieldAfter: CGFloat = 5
        static let descAfter: CGFloat = 5
    }
    
    // MARK: SubViews
    private let titleLabel = UILabel()
    private let inputFielView = UITextField()
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
    
    override func bind(reactor: NicknameInputReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: NicknameInputReactor) {
        inputFielView.rx.text
            .distinctUntilChanged()
            .map { $0 ?? "" }
            .map { Reactor.Action.setNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: NicknameInputReactor) {
        reactor.state.map { $0.isValidNickname }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.validationNickname($0.1) })
            .disposed(by: self.disposeBag)
    }
    
    override func setupUI() {
        
    }
    
    override func setupAutoLayout() {
        
    }
    
    override func setupAttributes() {
        addSubviews(titleLabel, inputFielView, errorMessageLabel, descLabel, nextButton)
    }
}

extension NicknameInputView {
    fileprivate func validationNickname(_ isValid: Bool) {
        nextButton.isEnabled = isValid
        errorMessageLabel.isHidden = !isValid
        inputFielView.textColor = isValid ? .black : .red
    }
}
