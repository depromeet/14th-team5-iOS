//
//  Direction.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import UIKit

extension BBToast {
    
    public enum Direction {
        case top(yOffset: CGFloat = 0)
        case bottom(yOffset: CGFloat = 0)
        case center(xOffset: CGFloat = 0, yOffset: CGFloat = 0)
    }
    
    public enum DismissSwipeDirection: Equatable {
        case toTop
        case toBottom
        case natural
        
        func shouldApply(_ delta: CGFloat, direction: Direction) -> Bool {
            switch self {
            case .toTop:
                return delta <= 0
            case .toBottom:
                return delta >= 0
            case .natural:
                switch direction {
                case .top:
                    return delta <= 0
                case .bottom:
                    return delta >= 0
                case .center:
                    return delta <= 0
                }
            }
        }
    }
    
}
