//
//  UIFont+Ext.swift
//  Core
//
//  Created by 김건우 on 12/29/23.
//

import UIKit

import DesignSystem

extension UIFont {
    public static func pretendard(_ textStyle: BibbiFontStyle) -> UIFont? {
        let attributes = fontAttributes(textStyle)
        return UIFont(
            font: attributes.font,
            size: attributes.size
        )
    }
}

extension UIFont {
    static func fontAttributes(
        _ textStyle: BibbiFontStyle = .title,
        textColor color: UIColor = .bibbiWhite,
        textAlignment: NSTextAlignment = .left
    ) -> FontAttributes {
        switch textStyle {
        case .homeFeed:
            return FontAttributes(
                size: 12,
                weight: .bold,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.38,
                alignment: textAlignment
            )
        case .title:
            return FontAttributes(
                size: 36.0, // 폰트 크기
                weight: .bold, // 폰트 굵기
                color: color, // 폰트 색상
                letterSpacing: -0.3, // 자간 (px)
                lineHeight: 1.38, // 높이 (%)
                alignment: textAlignment
            )
        case .head1:
            return FontAttributes(
                size: 24.0,
                weight: .bold,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.38,
                alignment: textAlignment
            )
        case .head2Bold:
            return FontAttributes(
                size: 18.0,
                weight: .semiBold,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.40,
                alignment: textAlignment
            )
        case .head2Regular:
            return FontAttributes(
                size: 18.0,
                weight: .regular,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.50,
                alignment: textAlignment
            )
        case .body1Bold:
            return FontAttributes(
                size: 16.0,
                weight: .semiBold,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.50,
                alignment: textAlignment
            )
        case .body1Regular:
            return FontAttributes(
                size: 16.0,
                weight: .regular,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.50,
                alignment: textAlignment
            )
        case .body2Bold:
            return FontAttributes(
                size: 14.0,
                weight: .semiBold,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.40,
                alignment: textAlignment
            )
        case .body2Regular:
            return FontAttributes(
                size: 14.0,
                weight: .regular,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.40,
                alignment: textAlignment
            )
        case .caption:
            return FontAttributes(
                size: 12.0,
                weight: .regular,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.50,
                alignment: textAlignment
            )
        }
    }
}

extension UIFont {
    public typealias BibbiFontStyle = Pretendard.Style
    public typealias BibbiFontFamily = Pretendard.Family
    
    public enum Pretendard {
        public enum Style {
            case title
            case homeFeed
            case head1
            case head2Bold
            case head2Regular
            case body1Bold
            case body1Regular
            case body2Bold
            case body2Regular
            case caption
        }
        
        public enum Family {
//            case black
//            case extraBold
            case bold
            case semiBold
//            case medium
            case regular
//            case thin
//            case light
//            case extraLight
        }
    }
    
    public struct FontAttributes {
        let size: CGFloat
        let weight: BibbiFontFamily
        let color: UIColor
        let letterSpacing: CGFloat
        let lineHeight: CGFloat
        let alignment: NSTextAlignment
    }
}


extension UIFont.FontAttributes {
    public var font: DesignSystemFontConvertible {
        switch weight {
//        case .black:
//            return DesignSystemFontFamily.Pretendard.black
//        case .extraBold:
//            return DesignSystemFontFamily.Pretendard.extraBold
        case .bold:
            return DesignSystemFontFamily.Pretendard.bold
        case .semiBold:
            return DesignSystemFontFamily.Pretendard.semiBold
//        case .medium:
//            return DesignSystemFontFamily.Pretendard.medium
        case .regular:
            return DesignSystemFontFamily.Pretendard.regular
//        case .thin:
//            return DesignSystemFontFamily.Pretendard.thin
//        case .light:
//            return DesignSystemFontFamily.Pretendard.light
//        case .extraLight:
//            return DesignSystemFontFamily.Pretendard.extraLight
        }
    }
}
