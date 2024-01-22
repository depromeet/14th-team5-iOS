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
    public var textStyle: UIFont.BibbiFontStyle {
        didSet {
            updateAttributes(textStyle)
        }
    }
    private var alignment: NSTextAlignment
    
    public override var text: String? {
        didSet {
            updateAttributes()
        }
    }
    
    
    public var textBibbiColor: UIColor = .bibbiWhite {
        didSet {
            updateAttributes()
        }
    }
    
    // MARK: - Intializer
    public init(
        _ style: UIFont.BibbiFontStyle,
        alignment: NSTextAlignment = .left,
        textColor color: UIColor = .bibbiWhite
    ) {
        self.textStyle = style
        self.alignment = alignment
        self.textBibbiColor = color
        super.init(frame: .zero)
        updateAttributes()
        numberOfLines = 0 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BibbiLabel {
    public func updateTextStyle(
        _ style: UIFont.BibbiFontStyle,
        alignment: NSTextAlignment = .left,
        textColor color: UIColor? = nil
    ) {
        self.textStyle = style
        self.alignment = alignment
        if let color = color {
            self.textBibbiColor = color
        }
        updateAttributes()
    }
}

extension BibbiLabel {
    private func updateAttributes(_ textStyle: UIFont.BibbiFontStyle) {
        let attributes = UIFont.fontAttributes(
            textStyle,
            textColor: textBibbiColor,
            textAlignment: alignment
        )
        setupBasicAttributes(attributes)
        setupDetailAttributes(attributes)
    }
    
    
    private func updateAttributes() {
        let attributes = UIFont.fontAttributes(
            textStyle,
            textColor: textBibbiColor,
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
