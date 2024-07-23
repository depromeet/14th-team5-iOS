//
//  JoinFamilyGroupNameViewController.swift
//  App
//
//  Created by Kim dohyun on 7/11/24.
//

import Core
import DesignSystem
import UIKit

import ReactorKit

final class JoinFamilyGroupNameViewController: BaseViewController<JoinFamilyGroupNameViewReactor> {
    
    private let groupNameLabel: BibbiLabel = BibbiLabel(.head2Bold, textAlignment: .center, textColor: .gray300)
    private let groupConfirmButton: BibbiButton = BibbiButton()
    private let groupTextField: UITextField = UITextField()
    private let groupDescrptionLabel: BibbiLabel = BibbiLabel(.body1Regular, textColor: .gray400)
    private let groupErrorStackView: UIStackView = UIStackView()
    private let groupErrorImageView: UIImageView = UIImageView()
    private let groupErrorLabel: BibbiLabel = BibbiLabel(.body1Regular, textColor: .warningRed)
    
    
    override func setupUI() {
        super.setupUI()
        groupErrorStackView.addArrangedSubviews(groupErrorImageView, groupErrorLabel)
        view.addSubviews(groupNameLabel, groupDescrptionLabel, groupTextField, groupConfirmButton, groupErrorStackView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        groupNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(130)
            $0.centerX.equalToSuperview().inset(20)
        }
        
        groupTextField.snp.makeConstraints {
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview().inset(20)
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
        
        groupConfirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            $0.height.equalTo(56)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, rightItem: .empty)
        }
        
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
    
    override func bind(reactor: JoinFamilyGroupNameViewReactor) {
        super.bind(reactor: reactor)
        groupTextField.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didChangeFamilyGroupNickname($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        groupConfirmButton.rx
            .tap
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapUpdateFamilyGroupNickname }
            .bind(to: reactor.action)
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

extension JoinFamilyGroupNameViewController {
    private func updateVaildationLayout(isEnabled: Bool) {
        groupConfirmButton.backgroundColor = isEnabled ? DesignSystemAsset.mainYellow.color : DesignSystemAsset.mainYellow.color.withAlphaComponent(0.2)
        groupConfirmButton.isEnabled = isEnabled
    }
    
    private func updateMaximumValidationLayout(isUpdate: Bool) {
        groupErrorStackView.isHidden = isUpdate
        groupTextField.textColor = isUpdate ? DesignSystemAsset.gray200.color : DesignSystemAsset.warningRed.color
        groupConfirmButton.isEnabled = isUpdate
        groupConfirmButton.backgroundColor = isUpdate ? DesignSystemAsset.mainYellow.color : DesignSystemAsset.mainYellow.color.withAlphaComponent(0.2)
    }
    
}
