//
//  PretendardFontLabel.swift
//  Core
//
//  Created by 김건우 on 12/28/23.
//

import UIKit

import DesignSystem

public class BibbiLabel: UILabel {
    // MARK: - Properties
    private let textStyle: UIFont.BibbiFontStyle
    
    public var textTypeSystemColor: UIColor = .bibbiWhite {
        didSet {
            let attributes = UIFont.fontAttributes(
                textColor: textTypeSystemColor
            )
            textColor = attributes.color
        }
    }
    
    // MARK: - Intializer
    public init(_ style: UIFont.BibbiFontStyle, textColor color: UIColor = .bibbiWhite) {
        self.textStyle = style
        self.textTypeSystemColor = color
        super.init(frame: .zero)
        setupAttributes(style, textColor: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupAttributes(_ textStyle: UIFont.BibbiFontStyle, textColor color: UIColor) {
        let attributes = UIFont.fontAttributes(
            textStyle,
            textColor: color
        )
        setupBasicAttributes(attributes)
        setupDetailAttributes(attributes)
    }
}

extension BibbiLabel {
    public override var text: String? {
        didSet {
            let attributes = UIFont.fontAttributes(
                textStyle
            )
            setupDetailAttributes(attributes)
        }
    }
}

extension BibbiLabel {
    private func setupBasicAttributes(_ attributes: UIFont.FontAttributes) {
        font = UIFont(
            font: attributes.font,
            size: attributes.size
        )
        textColor = attributes.color
    }
    
    private func setupDetailAttributes(_ attributes: UIFont.FontAttributes) {
        guard let text = text else { return }
        
        var attrString = NSMutableAttributedString(string: text)
        attrString = setLetterSpacingAttributes(attrString, letterSpacing: attributes.letterSpacing)
        attrString = setLineHeightPercentageAttributes(attrString, lienHiehgt: attributes.lineHeight)
        attributedText = attrString
    }
}
