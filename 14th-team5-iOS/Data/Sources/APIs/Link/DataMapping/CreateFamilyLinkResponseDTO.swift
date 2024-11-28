//
//  df.swift
//  Data
//
//  Created by 마경미 on 28.11.24.
//

import Domain

struct DetailResponseDTO: Decodable {
    let familyId: String
    let memberId: String
}

struct CreateFamilyLinkResponseDTO: Decodable {
    let linkId: String
    let url: String
    let type: String
    let details: DetailResponseDTO
    
    func toDomain() -> FamilyInvitationLinkEntity {
        return .init(url: url)
    }
}
