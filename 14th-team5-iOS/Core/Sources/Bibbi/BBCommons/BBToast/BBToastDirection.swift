//
//  Direction.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import UIKit

extension BBToast {
    
    /// Toast가 나타나는 방향을 정의합니다.
    public enum Direction {
        
        /// Toast가 위에서 아래로 나타나게 합니다.
        ///
        /// yOffset 연관값은 Toast가 화면 상단으로부터 얼마나 멀리 떨어져 있는지 의미합니다. 예를 들어, 400값을 준다면 상단으로부터 400만큼 떨어져서 Toast가 내려옵니다.
        ///
        /// 애니메이션 속도가 너무 빠르다면 애니메이션 시간을 조정하세요.
        case top(yOffset: CGFloat = 0)
        
        /// Toast가 아래에서 위로 나타나게 합니다.
        ///
        /// yOffset 연관값은 Toast가 화면 하단으로부터 얼마나 멀리 떨어져 있는지 의미합니다. 예를 들어, -400값을 준다면 하단으로부터 -400만큼 떨어져서 Toast가 올라옵니다.
        ///
        /// 애니메이션 속도가 너무 빠르다면 애니메이션 시간을 조정하세요.
        case bottom(yOffset: CGFloat = 0)
        
        /// Toast가 중앙에 나타나게 합니다.
        case center(xOffset: CGFloat = 0, yOffset: CGFloat = 0)
    }
    
    /// Toast가 어느 방향으로 스와이프하면 사라지는지 정의합니다.
    public enum DismissSwipeDirection: Equatable {
        
        /// 위로 스와이프해야 Toast가 사라지게 합니다.
        case toTop
        
        /// 아래로 스와이프해야 Toast가 사라지게 합니다.
        case toBottom
        
        /// Toast가 나타나는 방향에 따라 스와이프 방향을 자동으로 설정하게 합니다.
        case natural
        
        func shouldApply(_ delta: CGFloat, direction: Direction) -> Bool {
            switch self {
            case .toTop:
                return delta <= 0
            case .toBottom:
                return delta >= 0
            case .natural:
                switch direction {
                case .top:
                    return delta <= 0
                case .bottom:
                    return delta >= 0
                case .center:
                    return delta <= 0
                }
            }
        }
    }
    
}
