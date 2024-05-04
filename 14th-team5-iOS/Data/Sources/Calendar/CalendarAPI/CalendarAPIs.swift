//
//  CalendarAPIs.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Foundation

import Domain

enum CalendarAPIs: API {
    @available(*, deprecated)
    case calendarResponse(String)
    
    case monthlyCalendar(String)
    case dailyCalendar(String)
    case statisticsSummary(String)
    case calendarBenner(String)
    
    var spec: APISpec {
        switch self {
        case let .calendarResponse(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar?type=MONTHLY&yearMonth=\(yearMonth)")
            
        case let .monthlyCalendar(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar/monthly?yearMonth=\(yearMonth)")
        case let .dailyCalendar(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar/daily?yearMonthDay=\(yearMonth)")
        case let .statisticsSummary(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar/summary?yearMonth=\(yearMonth)")
        case let .calendarBenner(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar/banner?yearMonth=\(yearMonth)")
        }
    }
}
