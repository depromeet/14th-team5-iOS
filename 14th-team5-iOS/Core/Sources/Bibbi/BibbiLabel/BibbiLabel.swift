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
        didSet { setupText() }
    }
    
    public var fontStyle: BibbiFontStyle {
        didSet { setupFontStyle() }
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
        
        configureFontAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions
extension BibbiLabel {
    private func setupText() {
        let attr = UIFont.bibbiFontAttributes(fontStyle)
        
        guard let text = text else { return }
        let attrText = NSMutableAttributedString(string: text)
            .letterSpacing(attr.letterSpacing)
            .paragraphStyle(textAlignment, height: attr.lineHeight, font: font)
        self.attributedText = attrText
    }
    
    private func setupFontStyle() {
        self.font = UIFont.pretendard(fontStyle)
    }
    
    private func configureFontAttributes() {
        setupText()
        setupFontStyle()
    }
}
