//
//  AddFamiliyAPI.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Core

public enum FamilyAPIs: API {
    case createFamily
    case invitationUrl(String)
    case familyMembers(FamilySearchRequestDTO)

    var spec: APISpec {
        switch self {
        case let .createFamily:
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/me/create-family")
        case let .invitationUrl(familyId):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/links/family/\(familyId)")
        case let .familyMembers(query):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members?type=FAMILY&page=\(query.page)&size=\(query.size)")
        }
    }
}


    
