//
//  AccountAPIs.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import Core
import Foundation
import Domain

enum AccountAPIs: API {
    case forceToken(String)
    case refreshToken
    case signUp
    case signIn(SNS)
    case profileNickNameEdit(String)
    
    public var spec: APISpec {
        switch self {
        case .forceToken(let id):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/force-token/\(id)")
        case .refreshToken:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/refresh")
        case .signUp:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/register")
        case .signIn(let sns):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/social/\(sns.rawValue)")
        case .profileNickNameEdit(let memberId):
            return APISpec(method: .put, url: "\(BibbiAPI.hostApi)/members/name/\(memberId)")
        }
    }
    
    enum PayLoad {
        struct LoginPayload: Encodable, Equatable {
            var accessToken: String?
        }
        
        struct AccountSignUpPayLoad: Encodable, Equatable {
            public var memberName: String?
            public var dayOfBirth: String?
            public var profileImgUrl: String?
        }
    }
}
