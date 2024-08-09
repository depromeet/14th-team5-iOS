//
//  BBAlertStyle.swift
//  Core
//
//  Created by 김건우 on 8/9/24.
//

import Foundation

// MARK: - Typealias

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
    }
    
}
