//
//  BBToastConfiguration.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import UIKit

/// BBToast의 애니메이션, 오버랩 허용 유무를 설정할 수 있습니다.
///
/// - Note: 높이, 너비, 배경 색상과 둥글기 반경, 버튼 축 방향과 높이 등 BBToast 뷰에 대한 설정은 BBToastViewConfiguration에서 하세요.
///
/// - Authors: 김소월
public struct BBToastConfiguration {
    
    // MARK: - Properties
    
    /// Toast가 나타나는 방향입니다.
    public let direction: BBToast.Direction
    
    /// Toast가 사라지는 방법을 정의합니다.
    public let dismissables: [BBToast.Dismissable]
    
    /// Toast 애니메이션이 수행되는 시간입니다.
    public let animationTime: TimeInterval
    
    /// Toast가 나타날 때 수행되는 애니메이션입니다.
    public let enteringAnimation: BBToast.Animation
    
    /// Toast가 사라질 때 수행되는 애니메이션입니다.
    public let exitingAnimation: BBToast.Animation
    
    /// Toast 뒤에 배경의 색상을 설정합니다.
    public let background: BBToast.Background
    
    /// 여러 Toast의 겹치기 가능 여부를 설정합니다.
    public let allowToastOverlap: Bool
    
    /// Toast가 보여질 뷰를 설정합니다.
    public let view: UIView?
    
    
    // MARK: - Intializer
    
    /// BBToast의 애니메이션, 오버랩 허용 유무를 설정할 수 있습니다.
    /// - Parameters:
    ///   - direction: Toast가 나타나는 방향
    ///   - dismissables: Toast가 사라지는 방법
    ///   - animationTime: Toast 애니메이션 수행 시간
    ///   - enteringAnimation: Toast가 나타날 때 수행되는 애니메이션
    ///   - exitingAnimation: Toast가 사라질 때 수행되는 애니메이션
    ///   - view: Toast가 보여질 뷰
    ///   - background: Toast 뒤의 배경의 색상
    ///   - allowToastOverlap: Toast 겹치기 허용 유무
    public init(
        direction: BBToast.Direction = .bottom(yOffset: 0),
        dismissables: [BBToast.Dismissable] = [.time(time: 2.5), .swipe(direction: .natural)],
        animationTime: TimeInterval = 0.8,
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
        case let .top(yOffset):
            return .custom(
                transformation: CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: -yOffset - 300)
            )
            
        case let .bottom(yOffset):
            return .custom(
                transformation: CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: -yOffset + 300)
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
