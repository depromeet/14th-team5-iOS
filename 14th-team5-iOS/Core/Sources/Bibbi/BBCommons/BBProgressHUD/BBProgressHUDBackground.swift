//
//  BBProgressHUDBackground.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

extension BBProgressHUD {
    
    public enum Background {
        case none
        case color(color: UIColor = defaultImageTint.withAlphaComponent(0.25))
    }
    
}
