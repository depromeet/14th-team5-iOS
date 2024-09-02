//
//  MissionAPIs.swift
//  Data
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

enum MissionAPIs: API {
    case getTodayMission
    case getMissionContent(String)

    var spec: APISpec {
        switch self {
        case .getTodayMission:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/missions/today")
        case let .getMissionContent(missionId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/missions/\(missionId)")
        }
    }
}


    
