//
//  BBFontStyle.swift
//  Core
//
//  Created by 김건우 on 7/31/24.
//

import UIKit

import DesignSystem

public typealias BBFontStyle = BBLabel.PretendardStyle
public typealias BBFontFamily = BBLabel.PretendardFamily
public typealias BBFontAttributes = BBLabel.Font.Attributes

extension BBLabel {
    
    public typealias Attributes = Font.Attributes
    public typealias PretendardStyle = Font.Pretendard.Style
    public typealias PretendardFamily = Font.Pretendard.Family
    
    public enum Font {
        
        public enum Pretendard {
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
                case caption2
            }
            
            public enum Family {
                case bold
                case semiBold
                case regular
            }
        }
        
        public enum Cafe24 {
            public enum Style {
                
            }
            
            public enum Family {
                
            }
        }
        
        public struct Attributes {
            let size: CGFloat
            let weight: BBFontFamily
            let letterSpacing: CGFloat
            let lineHeight: CGFloat
        }
    }
    
}


extension BBLabel.Font.Attributes {
    
    public var font: DesignSystemFontConvertible {
        switch weight {
        case .bold:
            return DesignSystemFontFamily.Pretendard.bold
        case .semiBold:
            return DesignSystemFontFamily.Pretendard.semiBold
        case .regular:
            return DesignSystemFontFamily.Pretendard.regular
        }
    }
    
}

extension BBLabel {
    
    public static func pretendard(_ textStyle: BBFontStyle) -> UIFont? {
        let attributes = fontAttributes(textStyle)
        return UIFont(
            font: attributes.font,
            size: attributes.size
        )
    }
    
}

extension BBLabel {
    
    static func fontAttributes(
        _ fontStyle: BBFontStyle
    ) -> Attributes {
        switch fontStyle {
        case .title:
            return Attributes(
                size: 36.0, // 폰트 크기
                weight: .bold, // 폰트 굵기
                letterSpacing: -0.3, // 자간 (px)
                lineHeight: 1.38 // 높이 (%)
            )
        case .head1:
            return Attributes(
                size: 24.0,
                weight: .bold,
                letterSpacing: -0.3,
                lineHeight: 1.38
            )
        case .head2Bold:
            return Attributes(
                size: 18.0,
                weight: .semiBold,
                letterSpacing: -0.3,
                lineHeight: 1.40
            )
        case .head2Regular:
            return Attributes(
                size: 18.0,
                weight: .regular,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
        case .body1Bold:
            return Attributes(
                size: 16.0,
                weight: .semiBold,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
        case .body1Regular:
            return Attributes(
                size: 16.0,
                weight: .regular,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
        case .body2Bold:
            return Attributes(
                size: 14.0,
                weight: .semiBold,
                letterSpacing: -0.3,
                lineHeight: 1.40
            )
        case .body2Regular:
            return Attributes(
                size: 14.0,
                weight: .regular,
                letterSpacing: -0.3,
                lineHeight: 1.40
            )
        case .caption:
            return Attributes(
                size: 12.0,
                weight: .regular,
                letterSpacing: -0.3,
                lineHeight: 1.50
            )
        case .caption2:
            return Attributes(
                size: 12,
                weight: .bold,
                letterSpacing: -0.3,
                lineHeight: 1.38
            )
        }
    }
    
}
