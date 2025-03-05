//
//  BBProfileImage.swift
//  Core
//
//  Created by 마경미 on 04.01.25.
//

import UIKit

import DesignSystem

import RxSwift

public class BBProfileImage: UIView {
    internal let imageView: UIImageView = UIImageView()
    internal let defaultNameLabel: BBLabel = BBLabel(.head1, textColor: .gray200)
    internal let birthdayBadge: UIImageView = UIImageView()
    
    public enum Size: Int {
        case small = 32
        case medium = 48
        case large = 64
    }
    
    public struct Configure {
        let isBirthday: Bool
        let image: UIImage?
        let imageURL: String?
        let name: String?
        
        public init(
            isBirthday: Bool = false,
            imageURL: String?,
            name: String? = nil
        ) {
            self.isBirthday = isBirthday
            self.image = nil
            self.imageURL = imageURL
            self.name = name
        }
        
        public init(
            image: UIImage
        ) {
            self.isBirthday = false
            self.image = image
            self.imageURL = nil
            self.name = nil
        }
    }
    
    private let size: Size
    
    public init(size: Size) {
        self.size = size
        
        super.init(frame: .zero)
        
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BBProfileImage {
    private func setupUI() {
        addSubviews(imageView, defaultNameLabel, birthdayBadge)
    }
    
    private func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(size.rawValue)
            $0.directionalEdges.equalToSuperview()
        }
        
        defaultNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        birthdayBadge.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(20)
        }
    }
    
    private func setupAttributes() {
        imageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = CGFloat(size.rawValue / 2)
        }
        
        birthdayBadge.do {
            $0.isHidden = true
            $0.image = DesignSystemAsset.birthday.image
        }
    }
}

extension Reactive where Base: BBProfileImage {
    public var configure: Binder<BBProfileImage.Configure> {
        return Binder(base) { view, config in
            view.birthdayBadge.isHidden = !config.isBirthday
            
            if let imageURL = config.imageURL,
               let imageSource = URL(string: imageURL) {
                view.imageView.kf.setImage(with: imageSource)
            } else if let image = config.image {
                view.imageView.image = image
            } else {
                view.imageView.backgroundColor = .gray800
                view.defaultNameLabel.text = "\(config.name?.first ?? "알")"
            }
        }
    }
}
