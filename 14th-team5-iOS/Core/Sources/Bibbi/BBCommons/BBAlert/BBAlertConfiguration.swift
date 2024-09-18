//
//  BBAlertConfiguration.swift
//  BBAlert
//
//  Created by 김건우 on 8/6/24.
//

import UIKit

/// BBAlert의 애니메이션, 오버랩 허용 유무를 설정할 수 있습니다.
///
/// - Note: 높이, 너비, 배경 색상과 둥글기 반경, 버튼 축 방향과 높이 등 BBAlert 뷰에 대한 설정은 BBAlertViewConfiguration에서 하세요.
///
/// - Authors: 김소월
public struct BBAlertConfiguration {
    
    // MARK: - Properties
    
    /// Alert이 나타날 때 수행되는 애니메이션입니다.
    public let enteringAnimation: BBAlert.Animation
    
    /// Alert이 사라질 때 수행되는 애니메이션입니다.
    public let exitingAnimation: BBAlert.Animation
    
    /// Alert 뒤에 배경의 색상을 설정합니다.
    public let background: BBAlert.Background
    
    /// 여러 Alert의 겹치기 가능 여부를 설정합니다.
    public let allowOverlapAlert: Bool
    
    /// Alert이 보여질 뷰를 설정합니다.
    public let view: UIView?
    
    
    // MARK: - Intializer
    
    /// BBAlert의 애니메이션, 오버랩 허용 유무를 설정할 수 있습니다.
    /// - Parameters:
    ///   - view: Alert이 보여질 뷰
    ///   - enteringAnimation: Alert이 나타날 때 수행되는 애니메이션
    ///   - exitingAnimation: Alert이 사라질 때 수행되는 애니메이션
    ///   - background: Alert 뒤에 배경의 색상
    ///   - allowOverlapAlert: Alert 겹치기 허용 유무
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
