//
//  BBAlertStyle.swift
//  Core
//
//  Created by 김건우 on 8/9/24.
//

import Foundation

// MARK: - Typealias

/// BBAlert의 편리 사용을 위한 미리 정의되어 있는 Alert 스타일입니다.
///
/// - Authors: 김소월
public typealias BBAlertStyle = BBAlert.Style

extension BBAlert {
    
    public enum Style {
        case logout
        case makeNewFamily
        case resetFamilyName
        case widget
        case mission
        case picking(name: String)
        case takePhoto
        case uploadFailed
    }
    
}
