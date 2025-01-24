//
//  JoinFamilyGroupEdtiorView.swift
//  App
//
//  Created by Kim dohyun on 8/11/24.
//

import Core
import DesignSystem
import UIKit


final class JoinFamilyGroupEdtiorView: UIView {
    
    //MARK: Properties
    private let descrptionLabel: BBLabel = BBLabel(.body1Regular, textAlignment: .center, textColor: .gray400)
    let profileNameLabel: BBLabel = BBLabel(.head2Bold, textAlignment: .center, textColor: .gray200)
    let profileView: UIImageView = UIImageView()
    let userNameLabel: BBLabel = BBLabel(.body1Regular, textAlignment: .center, textColor: .gray400)
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    private func setupUI() {
        addSubviews(descrptionLabel, profileView, userNameLabel, profileNameLabel)
    }
    
    private func setupAutoLayout() {
        descrptionLabel.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.top.left.bottom.equalToSuperview()
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.center.equalTo(profileView)
        }
        
        profileView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.left.equalTo(descrptionLabel.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints {
            $0.left.equalTo(profileView.snp.right).offset(4)
            $0.height.equalTo(24)
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
    
    private func setupAttributes() {
        descrptionLabel.do {
            $0.text = "마지막 수정 :"
        }
        
        profileView.do {
            $0.layer.cornerRadius = 24 / 2
            $0.clipsToBounds = true
            $0.backgroundColor = DesignSystemAsset.gray800.color
        }
    }
}
