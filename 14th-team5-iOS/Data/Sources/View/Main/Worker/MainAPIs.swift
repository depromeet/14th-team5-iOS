//
//  MainAPIs.swift
//  Data
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

import Core

public enum MainAPIs: API {
    case fetchMain
    case fetchMainNight
    
    var spec: APISpec {
        switch self {
        case .fetchMain:
            let urlString = "\(BibbiAPI.hostApi)/view/main/daytime-page"
            return APISpec(method: .get, url: urlString)
        case .fetchMainNight:
            let urlString = "\(BibbiAPI.hostApi)/view/main/nighttime-page"
            return APISpec(method: .get, url: urlString)
        }
    }
}
