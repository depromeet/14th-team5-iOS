//
//  FamilyNameSettingViewController.swift
//  App
//
//  Created by Kim dohyun on 7/11/24.
//

import Core
import Util
import DesignSystem
import UIKit

import ReactorKit

final class FamilyNameSettingViewController: BBNavigationViewController<FamilyNameSettingViewReactor> {
    
    //MARK: Properties
    private let groupNameLabel: BBLabel = BBLabel(.head2Bold, textAlignment: .center, textColor: .gray300)
    private let groupConfirmButton: BBButton = BBButton()
    private let groupTextField: UITextField = UITextField()
    private let groupDescrptionLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray400)
    private let groupErrorStackView: UIStackView = UIStackView()
    private let groupErrorImageView: UIImageView = UIImageView()
    private let groupErrorLabel: BBLabel = BBLabel(.body1Regular, textColor: .warningRed)
    private let groupEditerView: JoinFamilyGroupEdtiorView = JoinFamilyGroupEdtiorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BBLogManager.analytics(logType: BBEventAnalyticsLog.viewPage(pageName: .familyGroupNameSetting))
    }
    
    //MARK: Configures
    override func setupUI() {
        super.setupUI()
        groupErrorStackView.addArrangedSubviews(groupErrorImageView, groupErrorLabel)
        view.addSubviews(groupNameLabel, groupDescrptionLabel, groupTextField, groupConfirmButton, groupErrorStackView, groupEditerView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        groupNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(130)
            $0.height.equalTo(25)
            $0.centerX.equalToSuperview()
        }
        
        groupTextField.snp.makeConstraints {
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        groupErrorStackView.snp.makeConstraints {
            $0.top.equalTo(groupTextField.snp.bottom).offset(12)
            $0.height.equalTo(24)
            $0.centerX.equalToSuperview()
        }
        
        groupErrorImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.left.equalToSuperview()
        }
        
        groupDescrptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(groupConfirmButton.snp.top).offset(-14)
        }
        
        groupEditerView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.bottom.equalTo(groupConfirmButton.snp.top).offset(-14)
            $0.centerX.equalToSuperview()
        }
        
        groupConfirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            $0.height.equalTo(56)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        groupNameLabel.do {
            $0.text = "가족 방 이름을 입력해주세요"
        }
        
        groupErrorStackView.do {
            $0.spacing = 4
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.isHidden = true
        }
        
        groupErrorLabel.do {
            $0.text = "10자 이내로 입력해주세요"
        }
        
        groupErrorImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = DesignSystemAsset.warning.image
        }
        
        groupTextField.do {
            $0.makePlaceholderAttributedString("나의 가족", attributed: [
                .font: DesignSystemFontFamily.Pretendard.bold.font(size: 36),
                .foregroundColor: DesignSystemAsset.gray700.color
            ])
            $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 36)
            $0.textColor = DesignSystemAsset.gray200.color
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
        
        groupDescrptionLabel.do {
            $0.text = "홈 화면에 가족 이름이 추가돼요 "
        }
        
        groupConfirmButton.do {
            $0.setTitle("저장", for: .normal)
            $0.setTitleFontStyle(.body1Bold)
            $0.setTitleColor(.bibbiBlack, for: .normal)
            $0.backgroundColor = .mainYellow.withAlphaComponent(0.2)
            $0.isEnabled = false
            $0.layer.cornerRadius = 28
        }
    }
    
    override func bind(reactor: FamilyNameSettingViewReactor) {
        super.bind(reactor: reactor)
        
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.rx.didTapRightBarButton
            .bind(with: self) { owner, _ in
                let alert = BBAlert.style(.resetFamilyName)
                alert.addDelegate(owner)
                alert.show()
            }
            .disposed(by: disposeBag)
                
        groupTextField.rx.text
            .orEmpty
            .skip(1)
            .map { Reactor.Action.didChangeFamilyGroupNickname($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        groupConfirmButton.rx
            .tap
            .throttle(RxInterval._100milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didTapUpdateFamilyGroupNickname(.update) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        groupConfirmButton
            .rx.tap
            .withLatestFrom(reactor.pulse(\.$familyNameEntity))
            .filter { $0 != nil }
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familyNameEntity)
            .filter { $0 != nil }
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familyNameEditorEntity)
            .compactMap { $0?.memberImage }
            .distinctUntilChanged()
            .bind(with: self) { owner, image in
                owner.groupEditerView.profileView.kf.setImage(with: image)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEdit }
            .distinctUntilChanged()
            .bind(to: groupEditerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !$0.isEdit }
            .distinctUntilChanged()
            .bind(to: groupDescrptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familyNameEditorEntity)
            .compactMap { $0?.memberName }
            .distinctUntilChanged()
            .bind(to: groupEditerView.userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familyNameEditorEntity)
            .compactMap { $0 }
            .filter { $0.memberImage.isFileURL }
            .compactMap { $0.memberName.first }
            .compactMap { "\($0)"}
            .bind(to: groupEditerView.profileNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familyNameEditorEntity)
            .compactMap { $0?.memberImage }
            .filter { $0.isFileURL == false }
            .bind(with: self) { owner, imageURL in
                owner.groupEditerView.profileView.kf.setImage(with: imageURL)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEdit }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { $0.0.updateNavigationBarLayout(isUpdate: $0.1) })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isNickNameVaildation }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.updateVaildationLayout(isEnabled: $0.1) })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isNickNameMaximumValidation }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.updateMaximumValidationLayout(isUpdate: $0.1) })
            .disposed(by: disposeBag)
    }
}

//MARK: Layout Extenions
extension FamilyNameSettingViewController {
    private func updateVaildationLayout(isEnabled: Bool) {
        groupConfirmButton.backgroundColor = isEnabled ? DesignSystemAsset.mainYellow.color : DesignSystemAsset.mainYellow.color.withAlphaComponent(0.2)
        groupConfirmButton.isEnabled = isEnabled
    }
    
    private func updateMaximumValidationLayout(isUpdate: Bool) {
        groupErrorStackView.isHidden = isUpdate
        groupTextField.textColor = isUpdate ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
    }
    
    private func updateNavigationBarLayout(isUpdate: Bool) {
        navigationBar.leftBarButtonItem = .arrowLeft
        navigationBar.rightBarButtonItem = isUpdate == true ? .none : .refresh
    }
}

//MARK: Delegate Extensions
extension FamilyNameSettingViewController: BBAlertDelegate {
    func willShowAlert(_ alert: Core.BBAlert) { }
    
    func didShowAlert(_ alert: Core.BBAlert) { }
    
    func willCloseAlert(_ alert: Core.BBAlert) { }
    
    func didCloseAlert(_ alert: Core.BBAlert) { }
    
    func didTapAlertButton(_ alert: BBAlert?, index: Int?, button: BBButton) {
        if index == 0 {
            alert?.close()
        } else {
            self.reactor?.action.onNext(.didTapUpdateFamilyGroupNickname(.initial))
        }
    }
}
