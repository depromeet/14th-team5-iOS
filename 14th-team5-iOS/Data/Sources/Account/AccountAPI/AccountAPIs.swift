//
//  AccountAPIs.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import Foundation
import Domain

enum AccountAPIs: API {
    case forceToken(String)
    case refreshToken
    case signUp
    case signIn(SNS)
    
    var spec: APISpec {
        switch self {
        case .forceToken(let id):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/force-token/\(id)")
        case .refreshToken:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/refresh")
        case .signUp:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/register")
        case .signIn(let sns):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/social/\(sns.rawValue)")
        }
    }
}
