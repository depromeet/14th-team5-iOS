//
//  CalendarAPIs.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Core
import Foundation

public enum CalendarAPIs: API {
    @available(*, deprecated)
    case calendarResponse(String)
    
    case fetchMonthlyCalendar(String)
    case fetchDailyCalendar(String)
    case fetchStatisticsSummary(String)
    case fetchBanner(String)
    
    public var spec: APISpec {
        switch self {
        case let .calendarResponse(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar?type=MONTHLY&yearMonth=\(yearMonth)")
            
        case let .fetchMonthlyCalendar(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar/monthly?yearMonth=\(yearMonth)")
        case let .fetchDailyCalendar(yearMonthDay):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar/daily?yearMonthDay=\(yearMonthDay)")
        case let .fetchStatisticsSummary(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar/summary?yearMonth=\(yearMonth)")
        case let .fetchBanner(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar/banner?yearMonth=\(yearMonth)")
        }
    }
}
