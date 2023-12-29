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
    var url: String
}

extension FamilyInvitationLinkResponseDTO {
    func toDomain() -> FamilyInvitationLinkResponse {
        return .init(url: url)
    }
}
