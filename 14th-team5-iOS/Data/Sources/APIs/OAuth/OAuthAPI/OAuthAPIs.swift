//
//  OAuthAPIs.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Core
import Foundation

public enum OAuthAPIs: API {
    case refreshToken
    case registerMember
    case signIn(SignInType)
    
    case registerFCMToken
    case deleteFCMToken(String)
    
    public var spec: APISpec {
        switch self {
        case .refreshToken:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/refresh")
        case .registerMember:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/register")
        case let .signIn(type):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/auth/social/\(type.rawValue)")
            
        case .registerFCMToken:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/fcm")
        case let .deleteFCMToken(token):
            return APISpec(method: .delete, url: "\(BibbiAPI.hostApi)/me/fcm/\(token)")
        }
    }
}
