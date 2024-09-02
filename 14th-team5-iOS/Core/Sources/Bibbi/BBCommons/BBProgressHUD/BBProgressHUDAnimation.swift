//
//  BBProgressHUDAnimation.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

extension BBProgressHUD {
    
    public enum Animation {
        case fade(alpha: CGFloat)
        case fadeAndScale(scaleX: CGFloat, scaleY: CGFloat, alpha: CGFloat)
        case custom(transformation: CGAffineTransform)
        case `default`
        
        func apply(to view: UIView) {
            switch self {
            case let .fade(alpha):
                view.alpha = alpha
                
            case let .fadeAndScale(scaleX, scaleY, alpha):
                view.alpha = alpha
                view.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                
            case let .custom(transformation):
                view.transform = transformation
                
            case .default:
                break
            }
        }
        
        func undo(from view: UIView) {
            switch self {
            @unknown default:
                view.alpha = 1
                view.transform = .identity
            }
        }
    }
    
}
