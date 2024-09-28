//
//  Animation.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import UIKit

extension BBToast {
    
    /// BBToast 뷰가 나타나거나 사라질 때 수행되는 애니메이션을 정의한 열거형입니다.
    ///
    /// BBToast 뷰가 나타날 때(enteringAnimation)는 뷰의 초기 상태를 전달해야 합니다. BBToast 뷰가 사라질 때(exitingAnimation)은 뷰의 최종 상태를 전달해야 합니다.
    ///
    /// 예를 들어, BBToast 뷰가 나타나거나 사라질 때 페이드 효과를 주기 원한다면 아래와 같이 ``BBToastConfiguration``을 설정해야 합니다.
    ///
    /// ```swift
    /// let config = BBToastConfiguration(
    ///     enteringAnimation: .fade(alpha: 0),
    ///     exitingAnimation: .fade(alpha: 0)
    /// )
    /// ```
    ///
    /// - Authors: 김소월
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
