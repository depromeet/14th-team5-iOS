//
//  BBAlertConfiguration.swift
//  BBAlert
//
//  Created by 김건우 on 8/6/24.
//

import UIKit

public struct BBAlertConfiguration {
    
    // MARK: - Properties
    
    public let enteringAnimation: BBAlert.Animation
    public let exitingAnimation: BBAlert.Animation
    public let background: BBAlert.Background
    public let allowOverlapAlert: Bool
    
    public let view: UIView?
    
    
    // MARK: - Intializer
    
    public init(
        attachedTo view: UIView? = nil,
        enteringAnimation: BBAlert.Animation = .default,
        exitingAnimation: BBAlert.Animation = .default,
        background: BBAlert.Background = .color(),
        allowOverlapAlert: Bool = false
    ) {
        self.view = view
        self.enteringAnimation = enteringAnimation.isDefault ? Self.defaultEnteringAnimation() : enteringAnimation
        self.exitingAnimation = exitingAnimation.isDefault ? Self.defaultExitingAnimation() : exitingAnimation
        self.background = background
        self.allowOverlapAlert = allowOverlapAlert
    }
    
}

// MARK: - Extensions

private extension BBAlertConfiguration {
    
    static func defaultEnteringAnimation() -> BBAlert.Animation {
        return .scaleAndFade(scaleX: 1.1, scaleY: 1.1, alpha: 0)
    }
    
    static func defaultExitingAnimation() -> BBAlert.Animation {
        return .fade(alpha: 0)
    }
    
}

fileprivate extension BBAlert.Animation {
    
    var isDefault: Bool {
        if case .default = self {
            return true
        }
        return false
    }
    
}
