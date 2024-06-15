//
//  JoinFamilyDTO.swift
//  Data
//
//  Created by 마경미 on 13.01.24.
//

import Domain
import Foundation

public struct JoinFamilyResponseDTO: Decodable {
    let familyId: String
    let createdAt: String
}

extension JoinFamilyResponseDTO {
    func toDomain() -> JoinFamilyEntity {
        return .init(
            familyId: familyId,
            createdAt: createdAt.iso8601ToDate()
        )
    }
}
