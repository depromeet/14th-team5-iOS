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
    case createFamily
    case fetchInvitationUrl(String)
    case fetchFamilyCreatedAt(String)
    case fetchPaginationFamilyMembers(Int, Int)
    case familyMembers(FamilySearchRequestDTO)

    var spec: APISpec {
        switch self {
        case .createFamily:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/create-family")
        case let .fetchInvitationUrl(familyId):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/links/family/\(familyId)")
        case let .fetchFamilyCreatedAt(familyId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/families/\(familyId)/created-at")
        case let .fetchPaginationFamilyMembers(page, size):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members?type=FAMILY&page=\(page)&size=\(size)")
        case let .familyMembers(query):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members?type=FAMILY&page=\(query.page)&size=\(query.size)")
        }
    }
}


    
