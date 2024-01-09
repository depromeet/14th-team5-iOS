//
//  FamilyInviteView.swift
//  App
//
//  Created by 마경미 on 17.12.23.
//

import UIKit
import Core
import DesignSystem

final class InviteFamilyView: UIView {
    typealias String = HomeStrings.InviteFamily
    typealias Layout = HomeAutoLayout.InviteFamilyView
    
    private let inviteImageView: UIImageView = UIImageView()
    private let labelStack: UIStackView = UIStackView()
    private let subLabel: UILabel = BibbiLabel(.body2Regular)
    private let titleLabel: UILabel = BibbiLabel(.head2Bold)
    private let nextIconImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        labelStack.addArrangedSubviews(subLabel, titleLabel)
        addSubviews(inviteImageView, labelStack,
                    nextIconImageView)
    }
    
    private func setupAutoLayout() {
        inviteImageView.snp.makeConstraints {
            $0.size.equalTo(Layout.InviteImageView.size)
            $0.leading.equalToSuperview().offset(Layout.InviteImageView.leadingInset)
            $0.centerY.equalToSuperview()
        }
        
        labelStack.snp.makeConstraints {
            $0.centerY.equalTo(inviteImageView)
            $0.leading.equalTo(inviteImageView.snp.trailing).offset(16)
        }
        
        nextIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Layout.NextIconImageView.trailingInset)
            $0.size.equalTo(Layout.NextIconImageView.size)
        }
    }
    
    private func setupAttributes() {
        backgroundColor = .gray900
        layer.cornerRadius = Layout.cornerRadius
        
        inviteImageView.do {
            $0.image = DesignSystemAsset.envelopeBackground.image
        }
        
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        subLabel.do {
            $0.text = String.subTitle
        }
        
        titleLabel.do {
            $0.text = String.title
        }
        
        nextIconImageView.do {
            $0.image = DesignSystemAsset.arrowRight.image
            $0.tintColor = .gray400
        }
    }
}
