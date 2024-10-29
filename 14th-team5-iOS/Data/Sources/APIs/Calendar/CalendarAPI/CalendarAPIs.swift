//
//  CalendarAPIs.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Core
import Foundation

enum CalendarAPIs: BBAPI {
    case fetchBannerInfo(String)
    case fetchStatisticsSummary(String)
    case fetchMonthlyCalendar(String)
    case fetchDailyCalendar(String)
    
    var spec: Spec {
        switch self {
        case let .fetchMonthlyCalendar(yearMonth):
            return Spec(
                method: .get,
                path: "/calendar",
                queryParameters: ["yearMonth": "\(yearMonth)", .type: "MONTHLY"]
            )
            
        case let .fetchDailyCalendar(yearMonthDay):
            return Spec(
                method: .get,
                path: "/calendar/daily",
                queryParameters: ["yearMonthDay": "\(yearMonthDay)"]
            )
            
        case let .fetchStatisticsSummary(yearMonth):
            return Spec(
                method: .get,
                path: "/calendar/summary",
                queryParameters: ["yearMonth": "\(yearMonth)"]
            )
            
        case let .fetchBannerInfo(yearMonth):
            return Spec(
                method: .get,
                path: "/calendar/banner",
                queryParameters: ["yearMonth": "\(yearMonth)"]
            )
        }
    }
    
}
