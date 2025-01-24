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
    
    enum InviteType {
        case makeUrl
        case inviteUrl
        
        var title: String {
            switch self {
            case .inviteUrl: return "그룹 입장하기"
            case .makeUrl: return "가족 초대하기"
            }
        }
        
        var subTitle: String {
            switch self {
            case .inviteUrl: return "이미 초대링크를 받았다면"
            case .makeUrl: return "이런, 아직 아무도 없군요"
            }
        }
    }
    
    private let inviteImageView: UIImageView = UIImageView()
    private let labelStack: UIStackView = UIStackView()
    private let subLabel: UILabel = BBLabel(.body2Regular)
    private let titleLabel: UILabel = BBLabel(.head2Bold)
    private let nextIconImageView: UIImageView = UIImageView()
    
    private var openType: InviteType
    
    init(frame: CGRect, openType: InviteType) {
        self.openType = openType
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    convenience init(openType: InviteType) {
        self.init(frame: .zero, openType: openType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        labelStack.addArrangedSubviews(subLabel, titleLabel)
        addSubviews(inviteImageView, labelStack, nextIconImageView)
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
        
        titleLabel.do {
            $0.text = openType.title
        }
        
        subLabel.do {
            $0.text = openType.subTitle
        }
        
        inviteImageView.do {
            $0.image = DesignSystemAsset.envelope.image
        }
        
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        nextIconImageView.do {
            $0.image = DesignSystemAsset.arrowRight.image
            $0.tintColor = .gray400
        }
    }
}
