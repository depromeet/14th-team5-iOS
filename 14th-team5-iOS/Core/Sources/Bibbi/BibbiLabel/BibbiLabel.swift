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
    public override var text: String? {
        didSet {
            setupText(text)
        }
    }
    
    public var fontStyle: BibbiFontStyle {
        didSet {
            setupFontStyle(fontStyle)
        }
    }
    
    // MARK: - Intializer
    public init(
        _ fontStyle: BibbiFontStyle = .body1Regular,
        textAlignment alignment: NSTextAlignment = .left,
        textColor color: UIColor = .bibbiWhite
    ) {
        self.fontStyle = fontStyle
        
        super.init(frame: .zero)
    
        self.textColor = color
        self.textAlignment = alignment
        
        configureBibbiFont()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions
extension BibbiLabel {
    private func setupText(_ text: String?) {
        self.setupAttributedString(fontStyle, text: text)
    }
    
    private func setupFontStyle(_ style: BibbiFontStyle) {
        self.font = UIFont.pretendard(style)
    }
    
    private func configureBibbiFont() {
        setupText(text)
        setupFontStyle(fontStyle)
    }
}

extension BibbiLabel {
    private func setupAttributedString(_ fontStlye: BibbiFontStyle) {
        self.setupAttributedString(fontStlye, text: self.text)
    }
    
    private func setupAttributedString(_ fontStyle: BibbiFontStyle, text: String?) {
        let attr = UIFont.bibbiFontAttributes(fontStyle)
        
        guard let text = text else { return }
        let attrText = NSMutableAttributedString(string: text)
            .letterSpacing(attr.letterSpacing)
            .lineHeight(attr.lineHeight, font: self.font)
        self.attributedText = attrText
    }
    
}
