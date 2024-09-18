//
//  BBAlertActionStyle.swift
//  Core
//
//  Created by 김건우 on 9/18/24.
//

import UIKit

// MARK: - Typealias

/// 버튼의 스타일을 설정합니다. 모든 `BBAlertAction`의 기본 스타일은 `default`입니다.
///
/// - Authors: 김소월
public typealias BBAlertActionStyle = BBAlertAction.Style

extension BBAlertAction {
    
    public enum Style {
        
        /// 가장 기본적인 버튼 스타일입니다.
        case `default`
        
        /// 취소 액션에 어울리는 버튼 스타일입니다.
        case cancel
        
        /// 주의를 요하는 액션에 어울리는 버튼 스타일입니다.
        case destructive
        
        /// 직접 원하는 폰트 스타일, 글자 색상, 배경 색상을 정할 수 있는 버튼 스타일입니다.
        case custom(
            titleFontStyle: BBFontStyle? = nil,
            titleColor: UIColor? = nil,
            backgroundColor: UIColor? = nil
        )
    }
    
}


// MARK: - Extension

extension BBAlertActionStyle {
    
    var titleFontStyle: BBFontStyle? {
        switch self {
        case .default,
             .cancel,
             .destructive:
            return BBFontStyle.body1Bold
            
        default:
            return nil
        }
    }
    
    var titleColor: UIColor? {
        switch self {
        case .default:
            return UIColor.bibbiBlack
            
        case .cancel:
            return UIColor.bibbiWhite
            
        case .destructive:
            return UIColor.systemRed
            
        default:
            return nil
        }
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .default:
            return UIColor.mainYellow
            
        case .destructive, .cancel:
            return UIColor.gray700
            
        default:
            return nil
        }
    }
    
}
