//
//  Animation.swift
//  BBAlert
//
//  Created by 김건우 on 8/7/24.
//

import UIKit

extension BBAlert {
    
    /// BBAlert 뷰가 나타나거나 사라질 때 수행되는 애니메이션을 정의한 열거형입니다.
    ///
    /// BBAlert 뷰가 나타날 때(enteringAnimation)는 뷰의 초기 상태를 전달해야 합니다. BBAlert 뷰가 사라질 때(exitingAnimation)은 뷰의 최종 상태를 전달해야 합니다.
    ///
    /// 예를 들어, BBAlert 뷰가 나타나거나 사라질 때 페이드 효과를 주기 원한다면 아래와 같이 ``BBAlertConfiguration``을 설정해야 합니다.
    ///
    /// ```swift
    /// let config = BBAlertConfiguration(
    ///     enteringAnimation: .fade(alpha: 0),
    ///     exitingAnimation: .fade(alpha: 0)
    /// )
    /// ```
    ///
    /// - Authors: 김소월
    public enum Animation {
        
        /// BBAlert 뷰에 페이드 효과를 줍니다.
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
