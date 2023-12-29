//
//  UIFont+Ext.swift
//  Core
//
//  Created by 김건우 on 12/29/23.
//

import UIKit

import DesignSystem

extension UIFont {
    public static func pretendard(_ textStyle: TypeSystemStyle) -> UIFont? {
        let attributes = fontAttributes(textStyle)
        return UIFont(
            font: attributes.font,
            size: attributes.size
        )
    }
}

extension UIFont {
    static func fontAttributes(_ textStyle: TypeSystemStyle = .title, textColor color: TypeSystemColor = .white) -> FontAttributes {
        switch textStyle {
        case .title:
            return FontAttributes(
                size: 36.0, // 폰트 크기
                weight: .bold, // 폰트 굵기
                color: color, // 폰트 색상
                letterSpacing: -0.3, // 자간 (px)
                lineHeight: 1.38 // 높이 (%)
            )
        case .head1:
            return FontAttributes(
                size: 24.0,
                weight: .bold,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.38
            )
        case .head2Bold:
            return FontAttributes(
                size: 18.0,
                weight: .semiBold,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.40
            )
        case .head2Regular:
            return FontAttributes(
                size: 18.0,
                weight: .regular,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
        case .body1Bold:
            return FontAttributes(
                size: 16.0,
                weight: .semiBold,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
        case .body1Regular:
            return FontAttributes(
                size: 16.0,
                weight: .regular,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
        case .body2Bold:
            return FontAttributes(
                size: 14.0,
                weight: .semiBold,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.40
            )
        case .body2Regular:
            return FontAttributes(
                size: 14.0,
                weight: .regular,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.40
            )
        case .caption:
            return FontAttributes(
                size: 12.0,
                weight: .regular,
                color: color,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
        }
    }
}

extension UIFont {
    public typealias TypeSystemStyle = TypeSystem.Style
    public typealias TypeSystemFamily = TypeSystem.Family
    public typealias TypeSystemColor = TypeSystem.Color
    
    public enum TypeSystem {
        public enum Style {
            case title
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
            case black
            case extraBold
            case bold
            case semiBold
            case medium
            case regular
            case thin
            case light
            case extraLight
        }
        
        public enum Color {
            case black
            case emojiYellow
            case graphicBlue
            case graphicPink
            case graphicPurple
            case gray100
            case gray200
            case gray300
            case gray400
            case gray500
            case gray600
            case gray700
            case gray800
            case gray900
            case mainGreen
            case mainGreenHover
            case warningRed
            case white
        }
    }
    
    public struct FontAttributes {
        let size: CGFloat
        let weight: TypeSystemFamily
        let color: TypeSystemColor
        let letterSpacing: CGFloat
        let lineHeight: CGFloat
        
        init(
            size: CGFloat,
            weight: TypeSystemFamily,
            color: TypeSystemColor,
            letterSpacing: CGFloat,
            lineHeight: CGFloat
        ) {
            self.size = size
            self.weight = weight
            self.color = color
            self.letterSpacing = letterSpacing
            self.lineHeight = lineHeight
        }
    }
}


extension UIFont.FontAttributes {
    public var font: DesignSystemFontConvertible {
        switch weight {
        case .black:
            return DesignSystemFontFamily.Pretendard.black
        case .extraBold:
            return DesignSystemFontFamily.Pretendard.extraBold
        case .bold:
            return DesignSystemFontFamily.Pretendard.bold
        case .semiBold:
            return DesignSystemFontFamily.Pretendard.semiBold
        case .medium:
            return DesignSystemFontFamily.Pretendard.medium
        case .regular:
            return DesignSystemFontFamily.Pretendard.regular
        case .thin:
            return DesignSystemFontFamily.Pretendard.thin
        case .light:
            return DesignSystemFontFamily.Pretendard.light
        case .extraLight:
            return DesignSystemFontFamily.Pretendard.extraLight
        }
    }
    
    public var textColor: UIColor {
        switch color {
        case .black:
            return DesignSystemAsset.black.color
        case .emojiYellow:
            return DesignSystemAsset.emojiYellow.color
        case .graphicBlue:
            return DesignSystemAsset.graphicBlue.color
        case .graphicPink:
            return DesignSystemAsset.graphicPink.color
        case .graphicPurple:
            return DesignSystemAsset.graphicPurple.color
        case .gray100:
            return DesignSystemAsset.gray100.color
        case .gray200:
            return DesignSystemAsset.gray200.color
        case .gray300:
            return DesignSystemAsset.gray300.color
        case .gray400:
            return DesignSystemAsset.gray400.color
        case .gray500:
            return DesignSystemAsset.gray500.color
        case .gray600:
            return DesignSystemAsset.gray600.color
        case .gray700:
            return DesignSystemAsset.gray700.color
        case .gray800:
            return DesignSystemAsset.gray800.color
        case .gray900:
            return DesignSystemAsset.gray900.color
        case .mainGreen:
            return DesignSystemAsset.mainGreen.color
        case .mainGreenHover:
            return DesignSystemAsset.mainGreenHover.color
        case .warningRed:
            return DesignSystemAsset.warningRed.color
        case .white:
            return DesignSystemAsset.white.color
        }
    }
}
