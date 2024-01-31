//
//  JoinFamilyDTO.swift
//  Data
//
//  Created by 마경미 on 13.01.24.
//

import Foundation

import Domain

public struct JoinFamilyRequestDTO: Codable {
    let inviteCode: String
}

struct JoinFamilyResponseDTO: Codable {
    let familyId: String
    let createdAt: String
}

extension JoinFamilyResponseDTO {
    func toDomain() -> JoinFamilyData {
        return .init(familyId: familyId)
    }
}
