//
//  CommentTextFieldView.swift
//  App
//
//  Created by 김건우 on 9/12/24.
//

import Core
import UIKit
import DesignSystem

import SnapKit
import Then
import RxSwift
import RxCocoa

public final class CommentTextFieldView: BaseView<CommentTextFieldReactor> {
    
    // MARK: - Views
    private let recorderManager: BBRecorderManager = BBRecorderManager()
    private let container: UIView = UIView()
    private let textFieldView: UITextField = UITextField()
    private let confirmButton: UIButton = UIButton(type: .system)
    let recordButton: UIButton = UIButton(type: .system)
    let equalizerView: BBEqualizerView = BBEqualizerView(state: .stop)
    
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
        
        recordButton
            .rx.tap
            .map { Reactor.Action.didTappedRecordButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.recorderManager.play()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CommentTextFieldReactor) {
        reactor.pulse(\.$inputText)
            .bind(to: textFieldView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.recordState }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: {$0.0.didUpdateTextFieldLayout($0.1)})
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$recordState)
            .bind(to: equalizerView.rx.state)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.enableTextField }
            .distinctUntilChanged()
            .bind(to: textFieldView.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.enableConfirmButton }
            .distinctUntilChanged()
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.pulse(\.$recordState),
            recorderManager.rx.requestCurrentTime
        )
        .filter { $0.0 == .play }
        .map { $0.1.toTimeInSeconds(.seconds) ?? 0.0 >= 1.0 ? true : false}
        .bind(to: confirmButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.pulse(\.$recordState),
            recorderManager.rx.requestDecibels
        )
        .filter { $0.0 == .play }
        .map { $0.1 }
        .observe(on: RxScheduler.main)
        .bind(to: equalizerView.rx.equalizerLevels)
        .disposed(by: disposeBag)
        
        recorderManager.rx
            .requestCurrentTime
            .distinctUntilChanged()
            .observe(on: RxScheduler.main)
            .bind(to: equalizerView.timerLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    public override func setupUI() {
        super.setupUI()
        addSubviews(container, textFieldView, recordButton, equalizerView, confirmButton)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textFieldView.snp.makeConstraints {
            $0.left.equalTo(recordButton.snp.right).offset(16)
            $0.right.equalTo(confirmButton.snp.left)
            $0.verticalEdges.equalToSuperview()
        }
        
        equalizerView.snp.makeConstraints {
            $0.left.equalTo(recordButton.snp.right).offset(16)
            $0.right.equalTo(confirmButton.snp.left)
            $0.verticalEdges.equalToSuperview()
        }
        
        recordButton.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(68)
            $0.height.equalTo(44)
            $0.right.equalToSuperview()
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        self.do {
            $0.backgroundColor = UIColor.gray900
        }
        
        equalizerView.do {
            $0.backgroundColor = .clear
        }
        
        textFieldView.do {
            $0.textColor = UIColor.bibbiWhite
            $0.backgroundColor = UIColor.clear
            $0.attributedPlaceholder = NSAttributedString(
                string: "댓글 달기...",
                attributes: [.foregroundColor: UIColor.gray300]
            )
            $0.returnKeyType = .done
            
            $0.delegate = self
        }
        
        confirmButton.do {
            $0.isEnabled = false
            $0.setTitle("등록", for: .normal)
            $0.tintColor = UIColor.mainYellow
            
            $0.addTarget(self, action: #selector(didTapConfirmButton(_:event:)), for: .touchUpInside)
        }
        
        recordButton.do {
            $0.setBackgroundImage(DesignSystemAsset.voice.image, for: .normal)
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
    
    func didUpdateTextFieldLayout(_ state: BBEqualizerState) {
        switch state {
        case .play:
            recordButton.setBackgroundImage(DesignSystemAsset.voiceOff.image, for: .normal)
            textFieldView.isHidden = true
            equalizerView.isHidden = false
            recorderManager.startRecoding()
        case .stop:
            recordButton.setBackgroundImage(DesignSystemAsset.voice.image, for: .normal)
            textFieldView.isHidden = false
            equalizerView.isHidden = true
            recorderManager.stopRecoding()
        }
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
