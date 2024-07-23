//
//  JoinFamilyGroupNameResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 7/23/24.
//

import Foundation

import Domain

public struct JoinFamilyGroupNameResponseDTO: Decodable {
    public let familyId: String
    public let familyName: String
    public let familyNameEditorId: String
    public let createdAt: String
}

extension JoinFamilyGroupNameResponseDTO {
    public func toDomain() -> JoinFamilyGroupNameEntity {
        return .init(
            familyid: familyId,
            familyName: familyName,
            familyNameEditorId: familyNameEditorId,
            familyCreateAt: createdAt
        )
    }
}
