//
//  InputFamilyLinkViewController.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import UIKit

import Core
import DesignSystem

final class InputFamilyLinkViewController: BaseViewController<InputFamilyLinkReactor> {
    // MARK: - Views
    private let backButton: UIButton = UIButton()
    private let titleLabel: BibbiLabel = BibbiLabel(.head2Bold, textColor: .gray300)
    private let linkTextField: UITextField = UITextField()
    private let joinFamilyButton: UIButton = UIButton()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubviews(backButton, titleLabel, linkTextField,
                         joinFamilyButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
//        backButton.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide).inset(44)
//            $0.horizontalEdges.equalToSuperview().inset(20)
//            $0.height.equalTo(66)
//        }
//        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(124)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        
        linkTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        joinFamilyButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
            $0.height.equalTo(56)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        linkTextField.do {
            $0.makePlaceholderAttributedString("https://no5ing.kr/", attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
        
        joinFamilyButton.do {
            $0.setTitle("그룹 입장하기", for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.mainGreen.color.withAlphaComponent(0.2)
            $0.isEnabled = false
            $0.layer.cornerRadius = 28
        }
    }
    
    override func bind(reactor: InputFamilyLinkReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: InputFamilyLinkReactor) {
        linkTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.inputLink($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        joinFamilyButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.tapJoinFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: InputFamilyLinkReactor) {
        reactor.state
            .map { $0.statusJoinFamily }
            .distinctUntilChanged()
            .filter { $0 }
            .withUnretained(self)
            .bind(onNext: {
                $0.0.showHomeViewController()
            })
            .disposed(by: disposeBag)
    }
}

extension InputFamilyLinkViewController {
    private func showHomeViewController() {
        
    }
}
