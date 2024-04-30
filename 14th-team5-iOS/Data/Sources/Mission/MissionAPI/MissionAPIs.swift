//
//  MissionAPIs.swift
//  Data
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

public enum MissionAPIs: API {
    case getTodayMission

    var spec: APISpec {
        switch self {
        case .getTodayMission:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/missions/today")
        }
    }
}


    
