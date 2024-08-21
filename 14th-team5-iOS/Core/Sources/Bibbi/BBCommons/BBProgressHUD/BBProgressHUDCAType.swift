//
//  BBProgressHUDStyle.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

// MARK: - Typealias

public typealias BBProgressHUDCAType = BBProgressHUD.CAType


// MARK: - Extensions

extension BBProgressHUD {
    
    public enum CAType {
        case spinner
        case circleRippleMultiple
        case horizontalDotScaling
    }
    
}
