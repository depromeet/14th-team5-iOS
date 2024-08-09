//
//  Background.swift
//  BBAlert
//
//  Created by 김건우 on 8/7/24.
//

import UIKit

extension BBAlert {
    
    public enum Background {
        case none
        case color(color: UIColor = defaultImageTint.withAlphaComponent(0.25))
    }
    
}
