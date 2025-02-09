//
//  BBProfile.swift
//  Core
//
//  Created by 마경미 on 23.12.24.
//

import UIKit

import SnapKit
import RxSwift

public class BBProfile: UIView {
    public enum Style {
        case imageTopTextBottom  // 이미지가 위, 텍스트가 아래 (상하)
        case imageLeftTextRight  // 이미지가 좌, 텍스트가 우 (좌우)
    }
    
    public struct Configure {
        let isBirthday: Bool
        let imageURL: String?
        let name: String
        let comment: String?
        
        public init(
            isBirthday: Bool = false,
            imageURL: String?,
            name: String,
            comment: String?
        ) {
            self.isBirthday = isBirthday
            self.imageURL = imageURL
            self.name = name
            self.comment = comment
        }
    }
    
    private let style: Style
    
    public var rx: Reactive<BBProfile> {
           return Reactive(self)
    }
    
    internal let imageView: BBProfileImage
    private let textStackView: UIStackView = UIStackView()
    internal let nameLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray200)
    internal let commentLabel: BBLabel = BBLabel(.caption, textColor: .gray500)
    
    public init(
        size: BBProfileImage.Size,
        style: Style
    ) {
        self.style = style
        self.imageView = .init(size: size)
        
        super.init(frame: .zero)
        
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BBProfile {
    private func setupUI() {
        addSubviews(imageView,textStackView)
        textStackView.addArrangedSubviews(nameLabel, commentLabel)
    }
    
    private func setupAutoLayout() {
        switch style {
        case .imageTopTextBottom:
            setupImageTopTextBottomAutoLayout()
        case .imageLeftTextRight:
            setupImageLeftTextRightAutoLayout()
        }
    }
    
    private func setupAttributes() {
        textStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fillProportionally
        }
    }
}

extension BBProfile {
    private func setupImageTopTextBottomAutoLayout() {
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.directionalVerticalEdges.trailing.equalToSuperview()
        }
    }
    
    private func setupImageLeftTextRightAutoLayout() {
        imageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension Reactive where Base: BBProfile {
    var configure: Binder<BBProfile.Configure> {
        return Binder(base) { view, config in
            view.imageView.rx.configure
                .onNext(
                    .init(
                        isBirthday: config.isBirthday,
                        imageURL: config.imageURL,
                        name: config.name
                    )
                )
            view.nameLabel.text = config.name
            view.commentLabel.text = config.comment
        }
    }
}

