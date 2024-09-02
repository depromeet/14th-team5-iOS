//
//  FamiliyInvitationLinkResponseDTO.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Domain
import Foundation

public struct FamilyInvitationLinkResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case linkId
        case url
        case type
        case details
    }
    var linkId: String
    var url: String
    var type: LinkType
    var details: [String: String]
}

extension FamilyInvitationLinkResponseDTO {
    enum LinkType: String, Decodable {
        case familyRegistration = "FAMILY_REGISTRATION"
        case postView = "POST_VIEW"
    }
}

extension FamilyInvitationLinkResponseDTO {
    func toDomain() -> FamilyInvitationLinkEntity {
        return .init(url: url)
    }
}
