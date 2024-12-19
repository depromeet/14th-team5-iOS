//
//  BBThumbnailToolTipView.swift
//  Core
//
//  Created by 김도현 on 10/27/24.
//

import UIKit

import SnapKit
import Then

public class BBThumbnailToolTipView: BBBaseToolTipView {
    // MARK: - Properties
    private let stackView: UIStackView = UIStackView()
    private let contentLabel: BBLabel = BBLabel()
    
    
    // MARK: - Intializer
    public override var intrinsicContentSize: CGSize {
        guard case let .waitingSurvivalImage(_, imageURLs) = toolTipType else {
            return .zero
        }
        let thumbnailWidth = CGFloat(24 * imageURLs.count)
        let labelWidth = contentLabel.intrinsicContentSize.width
        let contentWidth = thumbnailWidth + labelWidth + 38
        let contentHeight = max(stackView.intrinsicContentSize.height, contentLabel.intrinsicContentSize.height) + toolTipType.configure.arrowHeight + 20
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    public override init(toolTipType: BBToolTipType) {
        super.init(toolTipType: toolTipType)
        guard case let .waitingSurvivalImage(_, imageURLs) = toolTipType else {
            return
        }
        setupToolTipUI()
        setupToolTipContent()
        setupAutoLayout()
        setupThumbnailImageView(imageURL: imageURLs)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure
    public func setupToolTipUI() {
        addSubviews(stackView, contentLabel)
    }
    
    
    public func setupAutoLayout() {
        let arrowHeight: CGFloat = toolTipType.configure.arrowHeight
        let textPadding: CGFloat = 10
        guard case let .waitingSurvivalImage(_, imageURLs) = toolTipType else {
            return
        }
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(24 * imageURLs.count)
            $0.height.equalTo(24)
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalTo(contentLabel)
        }
        
        
        contentLabel.snp.makeConstraints {
            $0.left.equalTo(stackView.snp.right).offset(6)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(arrowHeight + textPadding)
            $0.top.equalToSuperview().inset(textPadding)
        }
    }
    
    public func setupToolTipContent() {
        stackView.do {
            $0.spacing = -4
            $0.distribution = .fillEqually
        }
        
        contentLabel.do {
            $0.text = toolTipType.configure.contentText
            $0.fontStyle = toolTipType.configure.font
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = toolTipType.configure.foregroundColor
            $0.sizeToFit()
        }
        
        self.do {
            $0.backgroundColor = .clear
        }
    }
    
    
    private func setupThumbnailImageView(imageURL: [URL]) {
        imageURL.forEach {
            let imageView: UIImageView = UIImageView(frame: .init(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.borderColor = UIColor.mainYellow.cgColor
            imageView.layer.borderWidth = 2
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.kf.setImage(with: $0)
            stackView.addArrangedSubview(imageView)
        }
    }
    
}
