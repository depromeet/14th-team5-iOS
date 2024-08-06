//
//  TextToastView.swift
//  BBToast
//
//  Created by 김건우 on 7/4/24.
//

import UIKit

public class TextToastView: UIStackView, BBToastStackView {
        
    // MARK: - Views
    
    private let titleLabel = BBLabel(.body1Regular)
    
    // MARK: - Properties
    
    public var toast: BBToast?
    
    // MARK: - Intializer
    
    public init(
        _ title: String,
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
        addArrangedSubview(titleLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        axis = .vertical
        alignment = .leading
        distribution = .fillEqually
    }
    
}
