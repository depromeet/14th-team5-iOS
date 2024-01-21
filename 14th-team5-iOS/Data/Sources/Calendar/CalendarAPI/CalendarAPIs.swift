//
//  CalendarAPIs.swift
//  Data
//
//  Created by 김건우 on 12/21/23.
//

import Foundation

import Domain

enum CalendarAPIs: API {
    case fetchCalendarResponse(String)
    case fetchStatisticsSummary(String)
    
    var spec: APISpec {
        switch self {
        case let .fetchCalendarResponse(yearMonth):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/calendar?type=MONTHLY&yearMonth=\(yearMonth)")
        case let .fetchStatisticsSummary(familyId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/families/\(familyId)/summary")
        }
    }
}
