//
//  AppAPIs.swift
//  Data
//
//  Created by 김건우 on 7/10/24.
//

import Core
import Foundation

public enum AppAPIs: API {
    
    case appVersion(String)
    
    public var spec: APISpec {
        switch self {
        case let .appVersion(appKey):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/me/app-version?appKey=\(appKey)")
        }
    }
    
}
