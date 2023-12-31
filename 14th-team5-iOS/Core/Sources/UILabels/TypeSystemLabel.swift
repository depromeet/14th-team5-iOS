//
//  PretendardFontLabel.swift
//  Core
//
//  Created by 김건우 on 12/28/23.
//

import UIKit

import DesignSystem

public class TypeSystemLabel: UILabel {
    // MARK: - Properties
    private let textStyle: UIFont.TypeSystemStyle
    
    public var textTypeSystemColor: UIFont.TypeSystemColor = .white {
        didSet {
            let attributes = UIFont.fontAttributes(
                textColor: textTypeSystemColor
            )
            textColor = attributes.textColor
        }
    }
    
    // MARK: - Intializer
    public init(_ style: UIFont.TypeSystemStyle, textColor color: UIFont.TypeSystemColor = .white) {
        self.textStyle = style
        self.textTypeSystemColor = color
        super.init(frame: .zero)
        setupAttributes(style, textColor: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupAttributes(_ textStyle: UIFont.TypeSystemStyle, textColor color: UIFont.TypeSystemColor) {
        let attributes = UIFont.fontAttributes(
            textStyle,
            textColor: color
        )
        setupBasicAttributes(attributes)
        setupDetailAttributes(attributes)
    }
}

extension TypeSystemLabel {
    public override var text: String? {
        didSet {
            let attributes = UIFont.fontAttributes(
                textStyle
            )
            setupDetailAttributes(attributes)
        }
    }
}

extension TypeSystemLabel {
    private func setupBasicAttributes(_ attributes: UIFont.FontAttributes) {
        font = UIFont(
            font: attributes.font,
            size: attributes.size
        )
        textColor = attributes.textColor
    }
    
    private func setupDetailAttributes(_ attributes: UIFont.FontAttributes) {
        guard let text = text else { return }
        
        var attrString = NSMutableAttributedString(string: text)
        attrString = setLetterSpacingAttributes(attrString, letterSpacing: attributes.letterSpacing)
        attrString = setLineHeightPercentageAttributes(attrString, lienHiehgt: attributes.lineHeight)
        attributedText = attrString
    }
}
