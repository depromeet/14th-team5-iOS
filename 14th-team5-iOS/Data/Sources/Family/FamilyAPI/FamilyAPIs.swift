//
//  AddFamiliyAPI.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Core
import Domain
import Foundation

public enum FamilyAPIs: API {
    case joinFamily
    case createFamily
    case resignFamily
    case fetchInvitationUrl(String)
    case fetchFamilyCreatedAt(String)
    case fetchPaginationFamilyMembers(Int, Int)

    var spec: APISpec {
        switch self {
        case .joinFamily:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/join-family")
        case .resignFamily:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/quit-family")
        case .createFamily:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/create-family")
        case let .fetchInvitationUrl(familyId):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/links/family/\(familyId)")
        case let .fetchFamilyCreatedAt(familyId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/families/\(familyId)/created-at")
        case let .fetchPaginationFamilyMembers(page, size):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members?type=FAMILY&page=\(page)&size=\(size)")
        }
    }
}


    
