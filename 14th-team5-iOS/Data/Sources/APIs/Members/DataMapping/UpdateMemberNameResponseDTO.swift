//
//  UpdateMemberNameResponseDTO.swift
//  Data
//
//  Created by 김도현 on 11/21/24.
//

import Foundation

import Domain


struct UpdateMemberNameResponseDTO: Decodable {
    let memberId: String
    let name: String
    let imageUrl: String?
    let familyId: String
    let familyJoinAt: String
    let dayOfBirth: String
}

extension UpdateMemberNameResponseDTO {
    func toDomain() -> UpdateMemberNameEntity {
        return .init(
            memberId: memberId,
            name: name,
            imageUrl: URL(string: imageUrl ?? "") ?? URL(fileURLWithPath: ""),
            familyId: familyId,
            familyJoinAt: familyJoinAt,
            dayOfBirth: dayOfBirth
        )
    }
}
