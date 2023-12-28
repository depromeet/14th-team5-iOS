//
//  UILabel+Ext.swift
//  Core
//
//  Created by 김건우 on 12/28/23.
//

import UIKit

import DesignSystem

extension UILabel {
    public enum Pretendard {
        public enum Weight {
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
        
        public enum TextColor {
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
    
    ///  Pretenard 폰트를 적용한 UILabel을 반환하는 함수입니다.
    ///
    /// - Parameters:
    ///   - size: 사이즈 (기본값 12)
    ///   - weight: 굵기 (기본값 regular)
    ///   - textColor: 색상 (기본값 white)
    /// - Returns: UILabel
    static public func createPretendardFontLabel(
        _ size: CGFloat = 12,
        weight: Pretendard.Weight = .regular,
        textColor: Pretendard.TextColor = .white
    ) -> UILabel {
        let label: UILabel = UILabel()
        let font: DesignSystemFontConvertible = pretendardFontWeight(weight)
        let textColor: DesignSystemColors = pretendardTextColor(textColor)
        
        label.font = UIFont(font: font, size: size)
        label.textColor = textColor.color
        
        return label
    }
    
    static private func pretendardTextColor(_ textColor: Pretendard.TextColor) -> DesignSystemColors {
        switch textColor {
        case .black:
            return DesignSystemAsset.black
        case .emojiYellow:
            return DesignSystemAsset.emojiYellow
        case .graphicBlue:
            return DesignSystemAsset.graphicBlue
        case .graphicPink:
            return DesignSystemAsset.graphicPink
        case .graphicPurple:
            return DesignSystemAsset.graphicPurple
        case .gray100:
            return DesignSystemAsset.gray100
        case .gray200:
            return DesignSystemAsset.gray200
        case .gray300:
            return DesignSystemAsset.gray300
        case .gray400:
            return DesignSystemAsset.gray400
        case .gray500:
            return DesignSystemAsset.gray500
        case .gray600:
            return DesignSystemAsset.gray600
        case .gray700:
            return DesignSystemAsset.gray700
        case .gray800:
            return DesignSystemAsset.gray800
        case .gray900:
            return DesignSystemAsset.gray900
        case .mainGreen:
            return DesignSystemAsset.mainGreen
        case .mainGreenHover:
            return DesignSystemAsset.mainGreenHover
        case .warningRed:
            return DesignSystemAsset.warningRed
        case .white:
            return DesignSystemAsset.white
        }
    }
    
    static private func pretendardFontWeight(_ weight: Pretendard.Weight) -> DesignSystemFontConvertible {
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
}
