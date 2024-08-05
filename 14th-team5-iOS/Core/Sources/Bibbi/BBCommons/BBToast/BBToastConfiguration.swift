//
//  BBToastConfiguration.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import UIKit

public struct BBToastConfiguration {
    
    // MARK: - Properties
    
    public let direction: BBToast.Direction
    public let dismissables: [BBToast.Dismissable]
    public let animationTime: TimeInterval
    public let enteringAnimation: BBToast.Animation
    public let exitingAnimation: BBToast.Animation
    public let background: BBToast.Background
    public let allowToastOverlap: Bool
    
    public let view: UIView?
    
    
    // MARK: - Intializer
    
    public init(
        direction: BBToast.Direction = .bottom(yOffset: 0),
        dismissables: [BBToast.Dismissable] = [.time(time: 2.5), .swipe(direction: .natural)],
        animationTime: TimeInterval = 0.6,
        enteringAnimation: BBToast.Animation = .default,
        exitingAnimation: BBToast.Animation = .default,
        attachTo view: UIView? = nil,
        background: BBToast.Background = .none,
        allowToastOverlap: Bool = false
    ) {
        self.direction = direction
        self.dismissables = dismissables
        self.animationTime = animationTime
        self.enteringAnimation = enteringAnimation.isDefualt ? Self.defaultEnteringAnimation(with: direction) : enteringAnimation
        self.exitingAnimation = exitingAnimation.isDefualt ? Self.defaultExitingAnimation(with: direction) : exitingAnimation
        self.background = background
        self.allowToastOverlap = allowToastOverlap
        self.view = view
    }
    
}


// MARK: - Extensions

private extension BBToastConfiguration {
    
    private static func defaultEnteringAnimation(with direction: BBToast.Direction) -> BBToast.Animation {
        switch direction {
        case .top:
            return .custom(
                transformation: CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: -100)
            )
            
        case .bottom:
            return .custom(
                transformation: CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: 100)
            )
            
        case .center:
            return .custom(
                transformation: CGAffineTransform(scaleX: 0.5, y: 0.5)
            )
        }
    }
    
    private static func defaultExitingAnimation(with direction: BBToast.Direction) -> BBToast.Animation {
        self.defaultEnteringAnimation(with: direction)
    }
    
}

fileprivate extension BBToast.Animation {
    
    var isDefualt: Bool {
        if case .default = self {
            return true
        }
        return false
    }
    
}
