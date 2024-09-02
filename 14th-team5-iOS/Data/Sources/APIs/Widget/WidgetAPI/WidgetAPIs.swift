//
//  WidgetAPIs.swift
//  Data
//
//  Created by 마경미 on 05.06.24.
//

import Foundation

import Core

enum WidgetAPIs: API {
    case fetchRecentFamilyPost
    
    public var spec: APISpec {
        switch self {
        case .fetchRecentFamilyPost:
            let urlString = "\(BibbiAPI.hostApi)/widgets/single-recent-family-post"
            return APISpec(method: .get, url: urlString)
        }
    }
}
