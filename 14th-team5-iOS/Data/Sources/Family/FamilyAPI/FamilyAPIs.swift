//
//  AddFamiliyAPI.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Core

public enum FamilyAPIs: API {
    case invitationUrl(String)
    case familyMembers
    
    var spec: APISpec {
        switch self {
        case let .invitationUrl(familiyId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/families/\(familiyId)/invitation-link")
        case .familyMembers:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members?type=FAMILY")
        }
    }
}

