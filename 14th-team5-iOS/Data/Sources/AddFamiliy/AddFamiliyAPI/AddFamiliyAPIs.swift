//
//  AddFamiliyAPI.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Core

enum AddFamiliyAPIs: API {
    case invitationUrl(String)
    case familiyMembers
    
    var spec: APISpec {
        switch self {
        case let .invitationUrl(familiyId):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/families/\(familiyId)/invitation-link")
        case .familiyMembers:
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/members?type=FAMILY")
        }
    }
}
