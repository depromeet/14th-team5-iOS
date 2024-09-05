//
//  BBProgressHUDConfiguration.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

public struct BBProgressHUDConfiguration {
    
    // MARK: - Properties
        
    public let animationTime: TimeInterval
    public let enteringAnimation: BBProgressHUD.Animation
    public let exitingAnimation: BBProgressHUD.Animation
    public let background: BBProgressHUD.Background
        
    public let view: UIView?
    
    public let allowProgressHUDOverlap: Bool


    // MARK: - Initalizer
        
    public init(
        animationTime: TimeInterval = 0.2,
        enteringAnimation: BBProgressHUD.Animation = .default,
        exitingAnimation: BBProgressHUD.Animation = .default,
        background: BBProgressHUD.Background = .none,
        attachedTo view: UIView? = nil,
        allowProgressHUDOverlap: Bool = false
    ) {
        self.animationTime = animationTime
        self.enteringAnimation = enteringAnimation.isDefault ? Self.defaultEnteringAnimation() : enteringAnimation
        self.exitingAnimation = exitingAnimation.isDefault ? Self.defaultExitingAnimation() : exitingAnimation
        self.background = background
        self.view = view
        self.allowProgressHUDOverlap = allowProgressHUDOverlap
    }

}


// MARK: - Extensions

extension BBProgressHUDConfiguration {
    
    private static func defaultEnteringAnimation() -> BBProgressHUD.Animation {
        return .fadeAndScale(scaleX: 0.9, scaleY: 0.9, alpha: 0)
    }
    
    private static func defaultExitingAnimation() -> BBProgressHUD.Animation {
        return .fade(alpha: 0)
    }
    
}

fileprivate extension BBProgressHUD.Animation {
    
    var isDefault: Bool {
        if case .default = self {
            return true
        }
        return false
    }
    
}
