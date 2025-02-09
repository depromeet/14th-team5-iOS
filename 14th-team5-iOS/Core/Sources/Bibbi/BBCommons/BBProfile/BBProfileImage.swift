//
//  BBProfileImage.swift
//  Core
//
//  Created by 마경미 on 04.01.25.
//

import UIKit

import RxSwift

public class BBProfileImage: UIView {
    internal let imageView: UIImageView = UIImageView()
    internal let defaultNameLabel: BBLabel = BBLabel(.title, textColor: .gray200)
    internal let birthdayBadge: UIImageView = UIImageView()
    
    public var rx: Reactive<BBProfileImage> {
           return Reactive(self)
    }
    
    enum Style {
        /// 이미지만 필요한 경우
        case normal
        /// 이미지 외, 생일 등의 정보가 필요한 경우
        case styled
    }
    
    public enum Size: Int {
        case small = 32
        case medium = 48
        case large = 64
    }
    
    public struct Configure {
        let isBirthday: Bool
        let imageURL: String?
        let name: String?
        
        public init(isBirthday: Bool, imageURL: String?, name: String?) {
            self.isBirthday = isBirthday
            self.imageURL = imageURL
            self.name = name
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
            $0.layer.cornerRadius = CGFloat(size.rawValue / 2)
        }
        
        birthdayBadge.do {
            $0.isHidden = true
        }
    }
}

extension Reactive where Base: BBProfileImage {
    public var configure: Binder<BBProfileImage.Configure> {
        return Binder(base) { view, config in
            if let imageURL = config.imageURL,
               let imageSource = URL(string: imageURL) {
                view.imageView.kf.setImage(with: imageSource)
            } else {
                view.imageView.backgroundColor = .black
                view.defaultNameLabel.text = config.name ?? ""
            }
            view.birthdayBadge.isHidden = !config.isBirthday
        }
    }
}
