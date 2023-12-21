//
//  UIFont+Ext.swift
//  Core
//
//  Created by 마경미 on 21.12.23.
//

import UIKit


public enum Pretendard {
    case bold
    case medium
    case semiBold
    case extraBold
    case regular
    
    var value: String {
        switch self {
        case .bold:
            return "Pretendard-Bold"
        case .medium:
            return "Pretendard-Medium"
        case .semiBold:
            return "Pretendard-SemiBold"
        case .extraBold:
            return "Pretendard-ExtraBold"
        case .regular:
            return "Pretendard-Regular"
        }
    }
}

public enum FontLevel {
    case title
    case head1
    case head2_bold
    case head2_regular
    case body1_bold
    case body1_regular
    case body2_bold
    case body2_regular
    case caption
}

extension FontLevel {
    public var fontWeight: String {
        switch self {
        case .title, .head1, .head2_bold, .body1_bold, .body2_bold:
            return Pretendard.semiBold.value
        case .head2_regular, .body1_regular, .body2_regular:
            return Pretendard.regular.value
        case .caption:
            return Pretendard.medium.value
        }
    }
    
    public var fontSize: CGFloat {
        switch self {
        case .title:
            return 36
        case .head1:
            return 24
        case .head2_bold, .head2_regular:
            return 18
        case .body1_bold, .body1_regular:
            return 16
        case .body2_bold, .body2_regular:
            return 14
        case .caption:
            return 12
        }
    }
}

extension UIFont {
    static public func pretendard(_ fontLevel: FontLevel) -> UIFont {
        return UIFont(name: fontLevel.fontWeight, size: fontLevel.fontSize) ?? UIFont.systemFont(ofSize: fontLevel.fontSize)
    }
}
