//
//  Background.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import UIKit

extension BBToast {
    
    public enum Background {
        case none
        case color(color: UIColor = defaultImageTint.withAlphaComponent(0.25))
    }
    
}
