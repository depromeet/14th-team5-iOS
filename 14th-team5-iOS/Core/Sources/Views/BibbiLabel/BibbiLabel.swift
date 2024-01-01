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
    private var textStyle: UIFont.BibbiFontStyle
    private var alignment: NSTextAlignment = .left // 기본 정렬 속성
    
    public var textTypeSystemColor: UIColor = .bibbiWhite {
        didSet {
            updateAttributes()
        }
    }
    
    // MARK: - Intializer
    public init(_ style: UIFont.BibbiFontStyle, alignment: NSTextAlignment = .left, textColor color: UIColor = .bibbiWhite) {
        self.textStyle = style
        self.alignment = alignment
        self.textTypeSystemColor = color
        super.init(frame: .zero)
        updateAttributes()
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
            updateAttributes()
        }
    }
}

extension BibbiLabel {
    public func updateTextStyle(_ style: UIFont.BibbiFontStyle, alignment: NSTextAlignment = .left, textColor color: UIColor? = nil) {
        self.textStyle = style
        self.alignment = alignment
        if let color = color {
            self.textTypeSystemColor = color
        }
        updateAttributes()
    }
    
    private func updateAttributes() {
        let attributes = UIFont.fontAttributes(
            textStyle,
            textColor: textTypeSystemColor,
            textAlignment: alignment
        )
        setupBasicAttributes(attributes)
        setupDetailAttributes(attributes)
    }
    
    private func setupBasicAttributes(_ attributes: UIFont.FontAttributes) {
        font = UIFont(
            font: attributes.font,
            size: attributes.size
        )
        textColor = attributes.color
        textAlignment = attributes.alignment
    }
    
    private func setupDetailAttributes(_ attributes: UIFont.FontAttributes) {
        guard let text = text else { return }
        
        var attrString = NSMutableAttributedString(string: text)
        attrString = setLetterSpacingAttributes(attrString, letterSpacing: attributes.letterSpacing)
        attrString = setLineHeightPercentageAttributes(attrString, lienHiehgt: attributes.lineHeight)
        attributedText = attrString
        
        textAlignment = attributes.alignment
    }
}
