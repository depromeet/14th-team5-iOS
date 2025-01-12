//
//  CommentTextFieldView.swift
//  App
//
//  Created by 김건우 on 9/12/24.
//

import Core
import UIKit

import SnapKit
import Then

public final class CommentTextFieldView: BaseView<CommentTextFieldReactor> {
    
    // MARK: - Views
    
    private let container: UIView = UIView()
    private let textFieldView: UITextField = UITextField()
    private let confirmButton: UIButton = UIButton(type: .system)
    
    // MARK: - Properties
    
    public weak var delegate: CommentTextFieldDelegate?
    
    
    // MARK: - Intializer
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    public override func bind(reactor: CommentTextFieldReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CommentTextFieldReactor) {
        textFieldView.rx.text
            .orEmpty
            .map { Reactor.Action.inputText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CommentTextFieldReactor) {
        reactor.pulse(\.$inputText)
            .bind(to: textFieldView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.enableTextField }
            .distinctUntilChanged()
            .bind(to: textFieldView.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.enableConfirmButton }
            .distinctUntilChanged()
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        addSubviews(container, textFieldView)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textFieldView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        self.do {
            $0.backgroundColor = UIColor.gray900
        }
        
        textFieldView.do {
            $0.textColor = UIColor.bibbiWhite
            $0.backgroundColor = UIColor.clear
            $0.attributedPlaceholder = NSAttributedString(
                string: "댓글 달기...",
                attributes: [.foregroundColor: UIColor.gray300]
            )
            
            $0.rightView = confirmButton
            $0.rightViewMode = .always
            $0.returnKeyType = .done
            
            $0.delegate = self
        }
        
        confirmButton.do {
            $0.isEnabled = false
            $0.setTitle("등록", for: .normal)
            $0.tintColor = UIColor.mainYellow
            
            $0.addTarget(self, action: #selector(didTapConfirmButton(_:event:)), for: .touchUpInside)
        }
    }
    
}


// MARK: - Extensions

extension CommentTextFieldView {
    
    func enableConfirmButton(enable: Bool) {
        confirmButton.isEnabled = enable
    }
    
    func enableCommentTextField(enable: Bool) {
        textFieldView.isEnabled = enable
    }
    
    func makeTextFieldFirstResponder() {
        textFieldView.becomeFirstResponder()
    }
    
    func assignText(_ toTextField: String? = nil) {
        textFieldView.text = toTextField
    }
    
}

extension CommentTextFieldView {
    
    @objc func didTapConfirmButton(_ button: UIButton, event: UIButton.Event) {
        delegate?.didTapConfirmButton?(button, text: textFieldView.text, event: event)
    }
    
}

extension CommentTextFieldView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didTapDoneButton?(text: textField.text)
        return true
    }
    
}
