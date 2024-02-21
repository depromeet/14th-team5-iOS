//
//  FamilyResponse.swift
//  Data
//
//  Created by 김건우 on 1/10/24.
//

import Foundation

import Domain

// MARK: - Data Transfer Object (DTO)
public struct CreateFamilyResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case familyId
        case createdAt
    }
    var familyId: String
    var createdAt: String
}

extension CreateFamilyResponseDTO {
    func toDomain() -> CreateFamilyResponse {
        return .init(
            familyId: familyId,
            createdAt: createdAt.iso8601ToDate()
        )
    }
}
