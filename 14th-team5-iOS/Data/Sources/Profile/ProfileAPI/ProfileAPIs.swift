//
//  ProfileAPIs.swift
//  Data
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation

import Core


enum ProfileAPIs: API {
    case profileMember(String)
    case profilePost
    
    var spec: APISpec {
        switch self {
        case let .profileMember(memberId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members/\(memberId)")
        case .profilePost:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/posts")
        }
    }
    
    
}
