//
//  Animation.swift
//  BBAlert
//
//  Created by 김건우 on 8/7/24.
//

import UIKit

extension BBAlert {
    
    public enum Animation {
        case fade(alpha: CGFloat)
        case scaleAndFade(scaleX: CGFloat, scaleY: CGFloat, alpha: CGFloat)
        case custom(transformation: CGAffineTransform)
        case `default`
        
        func apply(to view: UIView) {
            switch self {
            case let .fade(alpha):
                view.alpha = alpha
                
            case let .scaleAndFade(scaleX, scaleY, alpha):
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
            case .fade:
                view.alpha = 1
                
            case .scaleAndFade:
                view.alpha = 1
                view.transform = .identity
                
            case .custom:
                view.transform = .identity
                
            case .default:
                break
            }
        }
    }
    
}
