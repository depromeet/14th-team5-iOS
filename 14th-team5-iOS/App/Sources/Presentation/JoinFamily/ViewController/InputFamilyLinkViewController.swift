//
//  InputFamilyLinkViewController.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import UIKit

import Core
import Mixpanel
import DesignSystem

fileprivate typealias _Str = InviteFamilyStrings
final class InputFamilyLinkViewController: BaseViewController<InputFamilyLinkReactor> {
    private let backButton: UIButton = UIButton()
    private let titleLabel: UILabel = UILabel()
    private let linkTextField: UITextField = UITextField()
    private let joinFamilyButton: UIButton = UIButton()
    
    private var keyboardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        linkTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        linkTextField.resignFirstResponder()
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubviews(backButton, titleLabel, linkTextField, joinFamilyButton)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        backButton.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(52)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(176)
            $0.horizontalEdges.equalToSuperview().inset(20)
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
            $0.text = _Str.mainTitle
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 18.0)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .gray300
        }
        
        linkTextField.do {
            $0.makePlaceholderAttributedString(_Str.placeholder,
                                               attributed: [
                .font: UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)!,
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.text = UserDefaults.standard.inviteCode
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 36)
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.textAlignment = .center
        }
        
        joinFamilyButton.do {
            $0.setTitle(_Str.btnTitle, for: .normal)
            $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.semiBold, size: 16)
            $0.setTitleColor(DesignSystemAsset.black.color, for: .normal)
            $0.backgroundColor = DesignSystemAsset.mainYellow.color.withAlphaComponent(0.2)
            $0.isEnabled = UserDefaults.standard.inviteCode?.isEmpty == false
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
                $0.0.joinFamilyButton.backgroundColor = .mainYellow
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$showToastMessage)
            .observe(on: Schedulers.main)
            .filter { $0.count > 0 }
            .withUnretained(self)
            .bind(onNext: { $0.0.makeBibbiToastView(text: $0.1, image: DesignSystemAsset.warning.image, offset: $0.0.keyboardHeight + 90) })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPoped }
            .filter { $0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.navigationController?.popViewController(animated: true) })
            .disposed(by: disposeBag)
    }
}

extension InputFamilyLinkViewController {
    private func showHomeViewController() {
        
        UserDefaults.standard.clearInviteCode()
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: MainViewDIContainer().makeViewController())
        sceneDelegate.window?.makeKeyAndVisible()
    }
}
