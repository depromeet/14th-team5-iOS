//
//  IconTextView.swift
//  BBToast
//
//  Created by 김건우 on 7/4/24.
//

import UIKit

import Then

public class IconToastView: UIStackView, BBToastStackView {
    
    // MARK: - Views
    
    private let imageView = UIImageView()
    private let titleLabel = BBLabel(textAlignment: .center)

    // MARK: - Properties
    
    public var toast: BBToast? 
    
    
    // MARK: - Intializer
    
    public init(
        image: UIImage? = nil,
        imageTint: UIColor? = nil,
        title: String,
        titleColor: UIColor? = nil,
        titleFontStyle: BBFontStyle? = nil,
        viewConfig: BBToastViewConfiguration
    ) {
        super.init(frame: .zero)
        commonInit()
        
        if let image = image {
            imageView.image = image
            imageView.tintColor = imageTint
            imageView.contentMode = .scaleAspectFit
            addArrangedSubview(imageView)
        }

        titleLabel.text = title
        titleLabel.textColor = titleColor ?? .bibbiWhite
        titleLabel.fontStyle = titleFontStyle ?? .body1Regular
        titleLabel.numberOfLines = viewConfig.titleNumberOfLines
        titleLabel.textAlignment = .left
        addArrangedSubview(titleLabel)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        axis = .horizontal
        spacing = 5
        alignment = .center
        distribution = .fillProportionally
    }
    
}
