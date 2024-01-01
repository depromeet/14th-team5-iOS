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
    typealias Layout = HomeAutoLayout.InviteFamilyView
    
    private let inviteImageView: UIImageView = UIImageView()
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
        addSubviews(inviteImageView, subLabel, titleLabel,
                    nextIconImageView)
    }
    
    private func setupAutoLayout() {
        inviteImageView.snp.makeConstraints {
            $0.size.equalTo(Layout.InviteImageView.size)
            $0.leading.equalToSuperview().inset(Layout.InviteImageView.leadingInset)
            $0.centerY.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Layout.SubLabel.topInset)
            $0.leading.equalTo(inviteImageView.snp.trailing).offset(Layout.SubLabel.leadingOffset)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(Layout.TitleLabel.topOffset)
            $0.leading.equalTo(subLabel)
        }
        
        nextIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Layout.NextIconImageView.trailingInset)
            $0.size.equalTo(Layout.NextIconImageView.size)
        }
    }
    
    private func setupAttributes() {
        backgroundColor = DesignSystemAsset.gray900.color
        layer.cornerRadius = Layout.cornerRadius
        
        inviteImageView.do {
            $0.image = DesignSystemAsset.envelopeBackground.image
        }
        
        subLabel.do {
            $0.text = "이런, 아직 아무도 없군요!"
            $0.textColor = DesignSystemAsset.gray300.color
            $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        }
        
        titleLabel.do {
            $0.text = "가족 초대하기"
            $0.textColor = DesignSystemAsset.gray200.color
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        }
        
        nextIconImageView.do {
            $0.image = DesignSystemAsset.arrowRight.image
            $0.tintColor = DesignSystemAsset.gray400.color
        }
    }
}
