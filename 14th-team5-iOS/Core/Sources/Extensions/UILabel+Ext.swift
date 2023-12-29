//
//  UILabel+Ext.swift
//  Core
//
//  Created by 김건우 on 12/28/23.
//

import UIKit

extension UILabel {
    public func setLetterSpacingAttributes(_ attrString: NSMutableAttributedString, letterSpacing: CGFloat) -> NSMutableAttributedString {
        attrString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSMakeRange(0, attrString.length))
        return attrString
    }
    
    public func setLineHeightPercentageAttributes(_ attrString: NSMutableAttributedString, lienHiehgt percentage: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = (font.lineHeight - font.pointSize) * percentage
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        return attrString
    }
}
