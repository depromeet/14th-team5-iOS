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
    private let backButton: UIButton = UIButton()
    private let titleLabel: BibbiLabel = BibbiLabel(.head2Bold, alignment: .center, textColor: .gray300)
    private let linkTextField: UITextField = UITextField()
    private let joinFamilyButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubviews(backButton, titleLabel, linkTextField,
                         joinFamilyButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        backButton.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(52)
        }
        
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
        
        backButton.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .gray800
            $0.setImage(DesignSystemAsset.arrowLeft.image, for: .normal)
            $0.tintColor = .gray300
        }
        
        titleLabel.do {
            $0.text = "초대받은 링크를 입력해주세요"
        }
        
        linkTextField.do {
            $0.makePlaceholderAttributedString(UserDefaults.standard.inviteUrl ?? "https://no5ing.kr/",
                                               attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.textAlignment = .center
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
        
        backButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.tapPopButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: InputFamilyLinkReactor) {
        reactor.state
            .map { $0.isShowHome }
            .filter { $0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.showHomeViewController() })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.linkString }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: {
                $0.0.joinFamilyButton.isEnabled = true
                $0.0.joinFamilyButton.backgroundColor = .mainGreen
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPoped }
            .filter { $0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: {
                $0.0.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension InputFamilyLinkViewController {
    private func showHomeViewController() {
        let homeViewController = HomeDIContainer().makeViewController()
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
}
