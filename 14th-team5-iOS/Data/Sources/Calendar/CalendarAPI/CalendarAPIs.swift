//
//  CalendarAPIs.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Foundation

import Domain

enum CalendarAPIs: API {
    case calendarInfo(yearMonth: String)
    
    var spec: APISpec {
        switch self {
        case let .calendarInfo(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar?type=MONTHLY&yearMonth=\(yearMonth)")
        }
    }
}
