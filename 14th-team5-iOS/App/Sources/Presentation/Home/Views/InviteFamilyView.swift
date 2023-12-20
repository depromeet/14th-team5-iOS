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
    private let inviteImageView: UIImageView = UIImageView()
    private let subLabel: UILabel = UILabel()
    private let titleLabel: UILabel = UILabel()
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
            $0.size.equalTo(50)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(21)
            $0.leading.equalTo(inviteImageView.snp.trailing).offset(13)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(2)
            $0.leading.equalTo(subLabel)
        }
    }
    
    private func setupAttributes() {
        inviteImageView.do {
            $0.image = DesignSystemAsset.invite.image
        }
        
        subLabel.do {
            $0.text = "이런, 아직 아무도 없군요!"
        }
        
        titleLabel.do {
            $0.text = "가족 초대하기"
        }
    }
}
