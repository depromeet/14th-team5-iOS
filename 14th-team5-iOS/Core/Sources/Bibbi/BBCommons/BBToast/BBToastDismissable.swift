//
//  Dismissable.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import Foundation

extension BBToast {
    
    /// Toast가 사라지는 방법을 정의합니다.
    public enum Dismissable {
        case tap
        case longPress
        case time(time: TimeInterval)
        case swipe(direction: DismissSwipeDirection)
    }
    
}
