//
//  CalendarAPIs.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Foundation

enum CalendarAPIs: API {
    case monthlyCalendar(yearMonth: String)
    case weeklyCalendar(yearMonth: String, week: Int)
    
    var spec: APISpec {
        switch self {
        case let .monthlyCalendar(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar?type=MONTHLY&yearMonth=\(yearMonth)")
        case let .weeklyCalendar(yearMonth, week):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar?type=WEEKLY&yearMonth=\(yearMonth)&week=\(week)")
        }
    }
}
