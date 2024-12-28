//
//  BBProfile.swift
//  Core
//
//  Created by 마경미 on 23.12.24.
//

import UIKit

import SnapKit

class BBProfile: UIView {
    enum Style {
        case imageOnly       // 이미지만 있는 것
        case imageTopTextBottom  // 이미지가 위, 텍스트가 아래 (상하)
        case imageLeftTextRight  // 이미지가 좌, 텍스트가 우 (좌우)
    }
    
    enum Size: Int {
        case small = 32
        case medium = 48
        case large = 64
    }
    
    public struct Configure {
        let isBirthday: Bool
        let image: UIImage?
        let name: String
        let comment: String?
        
        public init(
            isBirthday: Bool = false,
            image: UIImage?,
            name: String,
            comment: String?
        ) {
            self.image = image
            self.name = name
            self.comment = comment
        }
    }
    
    private let style: Style
    private let size: Size
    
    internal let imageView: UIImageView = UIImageView()
    private let defaultNameLabel: BBLabel = BBLabel(.title ,textColor: .gray200)
    
    private let birthdayBadge: UIImageView = UIImageView()
    
    private let textStackView: UIStackView = UIStackView()
    private let nameLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray200)
    private let commentLabel: BBLabel = BBLabel(.caption, textColor: .gray500)
    
    public init(style: Style, size: Size) {
        self.style = style
        self.size = size
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BBProfile {
    private func setupUI() {
        addSubviews(imageView)
        imageView.addSubviews(defaultNameLabel)
        
        switch style {
        case .imageOnly: break
        case .imageLeftTextRight, .imageTopTextBottom:
            addSubviews(textStackView)
            imageView.addSubview(defaultNameLabel)
            textStackView.addArrangedSubviews(nameLabel, commentLabel)
        }
    }
    
    private func setupAutoLayout() {
        defaultNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        switch style {
        case .imageOnly:
            setupImageOnlyAutoLayout()
        case .imageTopTextBottom:
            setupImageTopTextBottomAutoLayout()
        case .imageLeftTextRight:
            setupImageLeftTextRightAutoLayout()
        }
    }
    
    private func setupAttributes() {
        imageView.do {
            $0.layer.cornerRadius = CGFloat(size.rawValue / 2)
        }
        
        textStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fillProportionally
        }
    }
}

extension BBProfile {
    private func setupImageOnlyAutoLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(size.rawValue)
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    private func setupImageTopTextBottomAutoLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(size.rawValue)
            $0.top.leading.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.directionalVerticalEdges.trailing.equalToSuperview()
        }
    }
    
    private func setupImageLeftTextRightAutoLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(size.rawValue)
            $0.top.leading.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension BBProfile {
    public func configure(
        with configure: Configure
    ) {
        if let image = configure.image {
            imageView.image = image
        } else {
            imageView.backgroundColor = .gray800
            defaultNameLabel.text = configure.name.first.map { String($0) }
        }
        
        nameLabel.text = configure.name
        commentLabel.text = configure.comment
    }
}
