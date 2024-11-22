//
//  CreateMemberPickResponseDTO.swift
//  Data
//
//  Created by 김도현 on 11/21/24.
//

import Foundation

import Domain

struct CreateMemberPickResponseDTO: Decodable {
    let success: Bool
}


extension CreateMemberPickResponseDTO {
    func toDomain() -> CreateMemberPickEntity {
        return .init(success: success)
    }
}

