//
//  Animation.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import UIKit

extension BBToast {
    
    public enum Animation {
        case slide(x: CGFloat, y: CGFloat)
        case fade(alpha: CGFloat)
        case scaleAndSlide(scaleX: CGFloat, scaleY: CGFloat, x: CGFloat, y: CGFloat)
        case scale(scaleX: CGFloat, scaleY: CGFloat)
        case custom(transformation: CGAffineTransform)
        case `default`
        
        func apply(to view: UIView) {
            switch self {
            case let .slide(x, y):
                view.transform = CGAffineTransform(translationX: x, y: y)
                
            case let .fade(alpha):
                view.alpha = alpha
                
            case let .scaleAndSlide(scaleX, scaleY, x, y):
                view.transform = CGAffineTransform(scaleX: scaleX, y: scaleY).translatedBy(x: x, y: y)
                    
            case let .scale(scaleX, scaleY):
                view.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                
            case let .custom(transformation):
                view.transform = transformation
                
            case .default:
                break
            }
        }
        
        func undo(from view: UIView) {
            switch self {
            case .slide, .scaleAndSlide, .scale, .custom:
                view.transform = .identity
                
            case .fade:
                view.alpha = 1.0
                
            case .`default`:
                break
            }
        }
    }
    
}
