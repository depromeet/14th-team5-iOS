//
//  FamilyNameResponseDTO.swift
//  Data
//
//  Created by 김건우 on 8/11/24.
//

import Domain
import Foundation

public struct FamilyNameResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case familyId
        case familyName
        case familyNameEditorId
        case createdAt
    }
    var familyId: String
    let familyName: String?
    let familyNameEditorId: String?
    var createdAt: String
}

extension FamilyNameResponseDTO {
    func toDomain() -> FamilyNameEntity {
        return .init(
            familyId: self.familyId,
            familyName: self.familyName ?? "",
            familyNameEditorId: self.familyNameEditorId ?? "",
            createdAt: self.createdAt.iso8601ToDate()
        )
    }
}
