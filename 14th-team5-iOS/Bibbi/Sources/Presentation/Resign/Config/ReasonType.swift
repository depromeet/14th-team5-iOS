//
//  ReasonType.swift
//  App
//
//  Created by 김도현 on 11/22/24.
//

import Foundation

public enum ReasonType: String, CaseIterable {
    case noNeedToShareDaily = "NO_NEED_TO_SHARE_DAILY"
    case familyMemberNotUsing = "FAMILY_MEMBER_NOT_USING"
    case noPreferWidgetOrNotification = "NO_PREFER_WIDGET_OR_NOTIFICATION"
    case serviceUxIsBad = "SERVICE_UX_IS_BAD"
    case noFrequencyUse = "NO_FREQUENTLY_USE"
    case none
    
    
    public var title: String {
        switch self {
        case .noNeedToShareDaily:
            return "가족과 일상을 공유하고 싶지 않아서"
        case .familyMemberNotUsing:
            return "가족 구성원이 참여하지 않아서"
        case .noPreferWidgetOrNotification:
            return "알림 및 위젯 기능을 선호하지 않아서"
        case .serviceUxIsBad:
            return "서비스 이용이 어렵거나 불편해서"
        case .noFrequencyUse:
            return "자주 사용하지 않아서"
        case .none:
            return ""
        }
    }
}
