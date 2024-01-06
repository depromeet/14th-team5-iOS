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
    public let profileNickNameButton: UIButton = UIButton(configuration: .plain())
    public var isSetting: Bool = false {
        didSet {
            setupUserProfile(isUser: isSetting)
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
        [profileImageView, profileNickNameButton, circleButton].forEach(self.addSubview(_:))
    }
    
    public func setupAttributes() {
        profileImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = cornerRadius
        }
        
        circleButton.do {
            $0.backgroundColor = .white
            $0.setImage(DesignSystemAsset.camera.image.withTintColor(DesignSystemAsset.gray700.color), for: .normal)
        }
        
        profileNickNameButton.do {
            $0.changesSelectionAsPrimaryAction = true
            $0.configuration?.imagePlacement = .trailing
            $0.configuration?.baseBackgroundColor = .clear
            $0.configurationUpdateHandler = { button in
                button.configuration?.image = button.isEnabled ? DesignSystemAsset.edit.image : nil
            }
            
            
            $0.configuration?.imagePadding = 5
            $0.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "하나밖에없는 혈육", attributes: [
                .foregroundColor: DesignSystemAsset.gray200.color,
                .font: DesignSystemFontFamily.Pretendard.semiBold.font(size: 16),
                .kern: -0.3
            ]))
        }
        
        

    }
    
    public func setupAutoLayout() {
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(2 * cornerRadius)
            $0.center.equalToSuperview()
        }
        
        circleButton.snp.makeConstraints {
            $0.right.equalTo(profileImageView).offset(-5)
            $0.bottom.equalTo(profileNickNameButton.snp.top).offset(-15)
        }
        
        profileNickNameButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.centerX.equalTo(profileImageView)
        }
    }
    
    private func setupUserProfile(isUser: Bool) {
        circleButton.isHidden = isUser
        circleButton.isEnabled = !isUser
        profileNickNameButton.isHidden = isUser
        profileNickNameButton.isEnabled = !isUser
    }
    
}
