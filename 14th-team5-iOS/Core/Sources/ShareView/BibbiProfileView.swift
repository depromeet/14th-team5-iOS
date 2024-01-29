//
//  BibbiProfileView.swift
//  Core
//
//  Created by Kim dohyun on 12/17/23.
//

import UIKit

import DesignSystem
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then




public class BibbiProfileView: UIView {
    public let profileImageView: UIImageView = UIImageView()
    public let circleButton: UIButton = UIButton.createCircleButton(radius: 15)
    public let birthDayView: UIImageView = UIImageView()
    public let profileNickNameButton: UIButton = UIButton()
    public let profileNickNameEditImageView: UIImageView = UIImageView()
    public let profileCreateLabel: UILabel = BibbiLabel(.caption, alignment: .center ,textColor: .gray400)
    
    
    public var isSetting: Bool = false {
        didSet {
            setupUserProfile(isUser: isSetting)
        }
    }
    
    public var isBirthDay: Bool = false {
        didSet {
            setupBirtyDay(isBirtyDay: isBirthDay)
        }
    }
    
    private var cornerRadius: CGFloat
    public init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        
        self.setupUI()
        self.setupAttributes()
        self.setupAutoLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setupUI() {
        addSubviews(profileImageView, profileNickNameButton, profileNickNameEditImageView, circleButton, birthDayView, profileCreateLabel)
    }
    
    public func setupAttributes() {
        profileImageView.do {
            $0.clipsToBounds = true
            $0.image = DesignSystemAsset.defaultProfile.image
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = cornerRadius
        }
        
        birthDayView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = DesignSystemAsset.birthday.image
        }
        
        circleButton.do {
            $0.backgroundColor = .white
            $0.setImage(DesignSystemAsset.camera.image.withTintColor(DesignSystemAsset.gray700.color), for: .normal)
        }
        
        profileNickNameEditImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = DesignSystemAsset.edit.image
        }
        
        profileNickNameButton.do {
            $0.titleLabel?.sizeToFit()
            $0.setAttributedTitle(NSAttributedString(string: "하나밖에없는 혈육", attributes: [
                .foregroundColor: DesignSystemAsset.gray200.color,
                .font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 16),
                .kern: -0.3
            ]), for: .normal)
        }
        
        

    }
    
    public func setupAutoLayout() {
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(2 * cornerRadius)
            $0.center.equalToSuperview()
        }
        
        birthDayView.snp.makeConstraints {
            $0.top.equalTo(profileImageView).offset(-8)
            $0.right.equalTo(profileImageView).offset(8)
            $0.width.height.equalTo(32)
        }
        
        profileCreateLabel.snp.makeConstraints {
            $0.top.equalTo(profileNickNameButton.snp.bottom).offset(4)
            $0.height.equalTo(17)
            $0.centerX.equalTo(profileNickNameButton)
        }
        
        circleButton.snp.makeConstraints {
            $0.right.equalTo(profileImageView).offset(-5)
            $0.bottom.equalTo(profileNickNameButton.snp.top).offset(-15)
        }
        
        profileNickNameButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.lessThanOrEqualToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.centerX.equalTo(profileImageView)
        }

        profileNickNameEditImageView.snp.makeConstraints {
            $0.height.width.equalTo(16)
            $0.left.equalTo(profileNickNameButton.snp.right).offset(4)
            $0.centerY.equalTo(profileNickNameButton).offset(2)
            $0.right.lessThanOrEqualToSuperview()
        }
    }
    
    private func setupUserProfile(isUser: Bool) {
        circleButton.isHidden = !isUser
        profileCreateLabel.isHidden = !isUser
        circleButton.isEnabled = isUser
        profileNickNameEditImageView.isHidden = !isUser
        profileNickNameButton.isEnabled = isUser
    }
    
    private func setupBirtyDay(isBirtyDay: Bool) {
        birthDayView.isHidden = !isHidden
    }
}
