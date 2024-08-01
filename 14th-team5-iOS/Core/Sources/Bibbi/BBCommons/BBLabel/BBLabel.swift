//
//  PretendardFontLabel.swift
//  Core
//
//  Created by 김건우 on 12/28/23.
//

import UIKit

import DesignSystem

public class BBLabel: UILabel {
    
    // MARK: - Properties
    
    public override var text: String? {
        didSet { setupText() }
    }
    
    public var fontStyle: BBFontStyle {
        didSet { setupFontStyle() }
    }
    
    
    // MARK: - Intializer
    
    public init(
        _ fontStyle: BBFontStyle = .body1Regular,
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

extension BBLabel {
    
    private func setupText() {
        let attr = UIFont.fontAttributes(fontStyle)
        
        guard let text = text else { return }
        let attrText = NSMutableAttributedString(string: text)
            .letterSpacing(attr.letterSpacing)
            .paragraphStyle(textAlignment, height: attr.lineHeight, font: font)
        self.attributedText = attrText
    }
    
    private func setupFontStyle() {
        self.font = UIFont.style(fontStyle)
    }
    
    private func configureFontAttributes() {
        setupText()
        setupFontStyle()
    }
    
}
