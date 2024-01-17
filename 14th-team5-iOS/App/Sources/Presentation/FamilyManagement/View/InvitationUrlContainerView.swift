//
//  InvitationUrlContainerView.swift
//  App
//
//  Created by 김건우 on 1/16/24.
//

import Core
import DesignSystem
import UIKit

public final class InvitationUrlContainerView: BaseView<InvitationUrlContainerViewReactor> {
    // MARK: - Views
    private let shareContainerView: UIView = UIView()
    private let envelopeImageView: UIImageView = UIImageView()
    
    private let labelStack: UIStackView = UIStackView()
    private let invitationDescLabel: BibbiLabel = BibbiLabel(.head2Bold, textColor: .gray200)
    private let invitationUrlLabel: BibbiLabel = BibbiLabel(.body2Regular, textColor: .gray300)
    private let shareLineImageView: UIImageView = UIImageView()
    private let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Intialzier
    public override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    public override func bind(reactor: InvitationUrlContainerViewReactor) { 
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: InvitationUrlContainerViewReactor) { }
    
    private func bindOutput(reactor: InvitationUrlContainerViewReactor) {
        reactor.state.map { !$0.shouldHiddenIndicatorView }
            .distinctUntilChanged()
            .bind(to: indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.shouldHiddenIndicatorView }
            .distinctUntilChanged()
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.shouldHiddenIndicatorView }
            .distinctUntilChanged()
            .bind(to: shareLineImageView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        self.addSubviews(
            shareContainerView
        )
        shareContainerView.addSubviews(
            envelopeImageView, labelStack, shareLineImageView, indicatorView
        )
        labelStack.addArrangedSubviews(
            invitationDescLabel, invitationUrlLabel
        )
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        shareContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        envelopeImageView.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.leading.equalTo(shareContainerView.snp.leading).offset(16)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
        
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(envelopeImageView.snp.trailing).offset(16)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
        
        shareLineImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(shareContainerView.snp.trailing).offset(-24)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
        
        indicatorView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalTo(shareContainerView.snp.trailing).offset(-24)
            $0.centerY.equalTo(shareContainerView.snp.centerY)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        shareContainerView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .gray800
        }
        
        envelopeImageView.do {
            $0.image = DesignSystemAsset.envelopeBackground.image
            $0.contentMode = .scaleAspectFit
        }
        
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.alignment = .leading
            $0.distribution = .fillProportionally
        }
        
        invitationDescLabel.do {
            $0.text = FamilyManagementStrings.inviteDescText
        }
        
        invitationUrlLabel.do {
            $0.text = FamilyManagementStrings.invitationUrlText
        }
        
        shareLineImageView.do {
            $0.image = DesignSystemAsset.shareLine.image
            $0.tintColor = .gray500
            $0.contentMode = .scaleAspectFit
        }
        
        indicatorView.do {
            $0.color = .bibbiWhite
            $0.isHidden = true
            $0.style = .medium
        }
    }
}
