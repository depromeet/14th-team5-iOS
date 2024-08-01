//
//  UIFont+Ext.swift
//  Core
//
//  Created by 김건우 on 12/29/23.
//

import UIKit

import DesignSystem

public typealias BBFontStyle = UIFont.FontStyle
public typealias BBFontAttributes = UIFont.FontAttributes

public extension UIFont {
    
    typealias FontStyle = UIFont.Style
    typealias FontAttributes = UIFont.Attributes
    
    enum Style {
        case homeTitle
        case title
        case head1
        case head2Bold
        case head2Regular
        case body1Bold
        case body1Regular
        case body2Bold
        case body2Regular
        case caption
        case caption2
    }
    
    struct Attributes {
        let size: CGFloat
        let letterSpacing: CGFloat
        let lineHeight: CGFloat
    }
    
}

public extension UIFont {
    
    /// Bibbi 스타일에 정의된 폰트를 불러옵니다. 폰트 사이즈도 함께 맞춰집니다.
    static func style(
        _ fontStyle: FontStyle
    ) -> UIFont? {
        let font = UIFont.font(fontStyle)
        let size = UIFont.fontAttributes(fontStyle).size
        
        return UIFont(
            font: font,
            size: size
        )
    }
    
}

public extension UIFont {
    
    // 폰트를 불러옵니다.
    static func font(
        _ fontStyle: FontStyle
    ) -> DesignSystemFontConvertible {
        switch fontStyle {
        case .homeTitle:
            return DesignSystemFontFamily.Cafe24SsurroundOTF.bold
        case .title:
            return DesignSystemFontFamily.Pretendard.bold
        case .head1:
            return DesignSystemFontFamily.Pretendard.bold
        case .head2Bold:
            return DesignSystemFontFamily.Pretendard.semiBold
        case .head2Regular:
            return DesignSystemFontFamily.Pretendard.regular
        case .body1Bold:
            return DesignSystemFontFamily.Pretendard.semiBold
        case .body1Regular:
            return DesignSystemFontFamily.Pretendard.regular
        case .body2Bold:
            return DesignSystemFontFamily.Pretendard.semiBold
        case .body2Regular:
            return DesignSystemFontFamily.Pretendard.regular
        case .caption:
            return DesignSystemFontFamily.Pretendard.regular
        case .caption2:
            return DesignSystemFontFamily.Pretendard.bold
        }
    }
    
}

public extension UIFont {
    
    // 폰트에 포함된 속성을 불러옵니다.
    static func fontAttributes(
        _ fontStyle: FontStyle
    ) -> FontAttributes {
        switch fontStyle {
        case .homeTitle:
            return FontAttributes(
                size: 18, // 폰트 크기
                letterSpacing: -0.3, // 자간 (px)
                lineHeight: 1.38 // 높이 (%)
            )
            
        case .title:
            return FontAttributes(
                size: 36.0,
                letterSpacing: -0.3,
                lineHeight: 1.38
            )
            
        case .head1:
            return FontAttributes(
                size: 24.0,
                letterSpacing: -0.3,
                lineHeight: 1.38
            )
            
        case .head2Bold:
            return FontAttributes(
                size: 18.0,
                letterSpacing: -0.3,
                lineHeight: 1.40
            )
            
        case .head2Regular:
            return FontAttributes(
                size: 18.0,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
            
        case .body1Bold:
            return FontAttributes(
                size: 16.0,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
            
        case .body1Regular:
            return FontAttributes(
                size: 16.0,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
            
        case .body2Bold:
            return FontAttributes(
                size: 14.0,
                letterSpacing: -0.3,
                lineHeight: 1.40
            )
            
        case .body2Regular:
            return FontAttributes(
                size: 14.0,
                letterSpacing: -0.3,
                lineHeight: 1.40
            )
            
        case .caption:
            return FontAttributes(
                size: 12.0,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
            
        case .caption2:
            return FontAttributes(
                size: 12,
                letterSpacing: -0.3,
                lineHeight: 1.38
            )
        }
    }
    
}
