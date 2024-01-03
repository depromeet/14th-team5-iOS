//
//  FamiliyInvitationLinkResponseDTO.swift
//  Data
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

import Domain

// MARK: - Data Transfer Object (DTO)
struct FamilyInvitationLinkResponseDTO: Decodable {
    var linkId: String
    let url: String
    let type: String
    let details: [String: String]
}

extension FamilyInvitationLinkResponseDTO {
    func toDomain() -> FamilyInvitationLinkResponse {
        return .init(url: url)
    }
}
