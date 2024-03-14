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
    public let profileDefaultLabel: BibbiLabel = BibbiLabel(.head1, alignment: .center, textColor: .gray200)
    public let circleButton: UIButton = UIButton.createCircleButton(radius: 15)
    public let birthDayView: UIImageView = UIImageView()
    public let profileNickNameButton: UIButton = UIButton()
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
    
    
    public func setupUI() {
        addSubviews(profileImageView, profileNickNameButton, profileDefaultLabel, circleButton, birthDayView, profileCreateLabel)
    }
    
    public func setupAttributes() {
        profileImageView.do {
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
            $0.image = DesignSystemAsset.defaultProfile.image
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = cornerRadius
            $0.backgroundColor = DesignSystemAsset.gray800.color
        }
        
        birthDayView.do {
            $0.isHidden = false
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
    
    public func setupAutoLayout() {
        
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
        
        profileNickNameButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.lessThanOrEqualToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.centerX.equalTo(profileImageView)
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
    }
    
    private func setupBirtyDay(isBirtyDay: Bool) {
        birthDayView.isHidden = !isBirtyDay
    }
}
