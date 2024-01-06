//
//  MeAPIs.swift
//  Data
//
//  Created by geonhui Yu on 1/3/24.
//

import Foundation
import Domain

public enum MeAPIs: API {
    case saveFcmToken
    case deleteFcmToken(String)
    case memberInfo
    
    var spec: APISpec {
        switch self {
        case .saveFcmToken:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/fcm")
        case .deleteFcmToken(let token):
            return APISpec(method: .delete, url: "\(BibbiAPI.hostApi)/me/fcm/\(token)")
        case .memberInfo:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/me/member-info")
        }
    }
    
    enum PayLoad {
        struct FcmPayload: Encodable, Equatable {
            var fcmToken: String?
        }
    }
}
