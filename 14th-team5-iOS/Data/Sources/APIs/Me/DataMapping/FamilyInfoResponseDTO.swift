//
//  FamilyGroupInfoResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 9/6/24.
//

import Foundation
import Domain


public struct FamilyInfoResponseDTO: Decodable {
    let familyId: String
    let familyName: String?
    let familyNameEditorId: String?
    let createdAt: String
}

extension FamilyInfoResponseDTO {
    func toDomain() -> FamilyGroupInfoEntity {
        return .init(
            familyId: familyId,
            familyName: familyName,
            familyNameEditorId: familyNameEditorId,
            createdAt: createdAt.iso8601ToDate()
        )
    }
}
