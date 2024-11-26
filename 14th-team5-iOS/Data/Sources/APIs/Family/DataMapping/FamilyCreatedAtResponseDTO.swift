//
//  FamilyCreatedAtResponseDTO.swift
//  Data
//
//  Created by 김건우 on 2/20/24.
//

import Domain
import Foundation

public struct FamilyCreatedAtResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case familyId
        case createdAt
    }
    var familyId: String
    var createdAt: String
}

extension FamilyCreatedAtResponseDTO {
    func toDomain() -> FamilyCreatedAtEntity {
        return .init(
            createdAt: createdAt.iso8601ToDate()
        )
    }
}
