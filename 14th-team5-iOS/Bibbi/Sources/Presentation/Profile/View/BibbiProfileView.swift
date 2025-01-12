//
//  BibbiProfileView.swift
//  App
//
//  Created by Kim dohyun on 10/9/24.
//

import UIKit

import Core
import DesignSystem
import SnapKit
import Then




final class BibbiProfileView: UIView {
    let profileImageView: UIImageView = UIImageView()
    let profileDefaultLabel: BBLabel = BBLabel(.head1, textAlignment: .center, textColor: .gray200)
    let circleButton: UIButton = UIButton.createCircleButton(radius: 15)
    let birthDayView: UIImageView = UIImageView()
    let profileNickNameButton: UIButton = UIButton()
    let profileCreateLabel: UILabel = BBLabel(.caption, textAlignment: .center ,textColor: .gray400)
    
    
    var isSetting: Bool = false {
        didSet {
            setupUserProfile(isUser: isSetting)
        }
    }
    
    var isBirthDay: Bool = false {
        didSet {
            setupBirtyDay(isBirtyDay: isBirthDay)
        }
    }
    
    public var isDefault: Bool = false {
        didSet {
            setupDefaultProfile(isDefault: isDefault)
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
    
    
    private func setupUI() {
        addSubviews(profileImageView, profileNickNameButton, profileDefaultLabel, circleButton, birthDayView, profileCreateLabel)
    }
    
    private func setupAttributes() {
        profileImageView.do {
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
            $0.image = DesignSystemAsset.defaultProfile.image
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = cornerRadius
            $0.backgroundColor = DesignSystemAsset.gray800.color
        }
        
        birthDayView.do {
            $0.isHidden = true
            $0.contentMode = .scaleAspectFill
            $0.image = DesignSystemAsset.birthday.image
        }
        
        circleButton.do {
            $0.backgroundColor = .white
            $0.setImage(DesignSystemAsset.camera.image.withTintColor(DesignSystemAsset.gray700.color), for: .normal)
        }
        
        profileNickNameButton.do {
            $0.configuration = .plain()
            $0.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "하나밖에없는 혈육", attributes: [
                .foregroundColor: DesignSystemAsset.gray200.color,
                .font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 16),
                .kern: -0.3
            ]))
            let imageSize = CGSize(width: 16, height: 16)
            $0.configuration?.imagePlacement = .trailing
            $0.changesSelectionAsPrimaryAction = true
            $0.configurationUpdateHandler = { button in
                button.configuration?.image = button.isEnabled ? DesignSystemAsset.edit.image.resized(to: imageSize) : nil
            }
            $0.configuration?.imagePadding = 5
            $0.configuration?.baseBackgroundColor = .clear
        }
        
        

    }
    
    private func setupAutoLayout() {
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.width.height.equalTo(2 * cornerRadius)
            $0.centerX.equalToSuperview()
        }
        
        profileDefaultLabel.snp.makeConstraints {
            $0.center.equalTo(profileImageView)
        }
        
        birthDayView.snp.makeConstraints {
            $0.top.equalTo(profileImageView).offset(-8)
            $0.right.equalTo(profileImageView).offset(8)
            $0.width.height.equalTo(32)
        }
        
        profileCreateLabel.snp.makeConstraints {
            $0.top.equalTo(profileNickNameButton.snp.bottom).offset(12)
            $0.height.equalTo(17)
            $0.centerX.equalTo(profileNickNameButton)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        circleButton.snp.makeConstraints {
            $0.right.equalTo(profileImageView).offset(-5)
            $0.bottom.equalTo(profileImageView)
        }
        
    }
    
    private func setupDefaultProfile(isDefault: Bool) {
        profileDefaultLabel.isHidden = !isDefault
        guard isDefault else { return }
        profileImageView.image = nil
    }
    
    private func setupUserProfile(isUser: Bool) {
        circleButton.isHidden = !isUser
        profileCreateLabel.isHidden = !isUser
        circleButton.isEnabled = isUser
        profileNickNameButton.isEnabled = isUser
        
        if !isUser {
            profileNickNameButton.snp.remakeConstraints {
                $0.width.lessThanOrEqualToSuperview()
                $0.top.equalTo(profileImageView.snp.bottom).offset(12)
                $0.centerX.equalTo(profileImageView)
                $0.bottom.equalToSuperview().offset(-24)
            }
            
        } else {
            profileNickNameButton.snp.remakeConstraints {
                $0.height.equalTo(24)
                $0.width.lessThanOrEqualToSuperview()
                $0.top.equalTo(profileImageView.snp.bottom).offset(12)
                $0.centerX.equalTo(profileImageView)
            }
        }
        
    }
    
    private func setupBirtyDay(isBirtyDay: Bool) {
        birthDayView.isHidden = !isBirtyDay
    }
}

