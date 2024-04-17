//
//  UILabel+Ext.swift
//  Core
//
//  Created by 김건우 on 12/28/23.
//

import UIKit

extension NSMutableAttributedString {
    public func lineHeight(_ height: CGFloat, font: UIFont) -> Self {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = (font.lineHeight - font.pointSize) * height
        self.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraph,
            range: NSMakeRange(0, self.length)
        )
        return self
    }
    
    public func letterSpacing(_ spacing: CGFloat) -> Self {
        self.addAttribute(
            NSAttributedString.Key.kern,
            value: spacing,
            range: NSMakeRange(0, self.length)
        )
        return self
    }
}
