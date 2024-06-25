//
//  MeAPIs.swift
//  Data
//
//  Created by geonhui Yu on 1/3/24.
//

import Core
import Foundation

public enum MeAPIs: API {
    case saveFcmToken
    case deleteFcmToken(String)
    case memberInfo
    case joinFamily
    case appVersion
    
    public var spec: APISpec {
        switch self {
        case .saveFcmToken:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/fcm")
        case .deleteFcmToken(let token):
            return APISpec(method: .delete, url: "\(BibbiAPI.hostApi)/me/fcm/\(token)")
        case .memberInfo:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/me/member-info")
        case .joinFamily:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/join-family")
        case .appVersion:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/me/app-version")
        }
    }
    
    enum PayLoad {
        struct FcmPayload: Encodable, Equatable {
            var fcmToken: String?
        }
        struct FamilyPayload: Encodable, Equatable {
            var inviteCode: String
        }
    }
}
