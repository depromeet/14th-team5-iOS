//
//  FamilyCreatedAtResponse.swift
//  Data
//
//  Created by 김건우 on 1/6/24.
//

import Foundation

import Domain

// MARK: - Data Transfer Data (DTO)
struct FamilyCreatedAtResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case familyId
        case createdAt
    }
    var familyId: String
    var createdAt: String
}

extension FamilyCreatedAtResponseDTO {
    func toDomain() -> FamilyCreatedAtResponse {
        return .init(
            createdAt: createdAt.iso8601ToDate()
        )
    }
}

