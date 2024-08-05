//
//  IconTextView.swift
//  BBToast
//
//  Created by 김건우 on 7/4/24.
//

import UIKit

import Then

public class IconToastView: UIStackView {
    
    // MARK: - Views
    
    private let vStack = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = BBLabel(textAlignment: .center)
    
    
    // MARK: - Intializer
    
    public init(
        image: UIImage,
        imageTint: UIColor? = nil,
        title: String,
        titleColor: UIColor? = nil,
        titleFontStyle: BBFontStyle? = nil,
        viewConfig: BBToastViewConfiguration
    ) {
        super.init(frame: .zero)
        commonInit()
        
        titleLabel.text = title
        titleLabel.textColor = titleColor ?? .bibbiWhite
        titleLabel.fontStyle = titleFontStyle ?? .body1Regular
        titleLabel.numberOfLines = viewConfig.titleNumberOfLines
        vStack.addArrangedSubview(titleLabel)
        
        imageView.image = image
        imageView.tintColor = imageTint
        
        addArrangedSubview(imageView)
        addArrangedSubview(vStack)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        axis = .horizontal
        spacing = 15
        alignment = .center
        distribution = .fill
        
        setupAttributes()
    }
    
    
    // MARK: - Helpers
    
    private func setupAttributes() {
        vStack.do {
            $0.axis = .vertical
            $0.spacing = 2
            $0.alignment = .leading
        }
    }
    
}
