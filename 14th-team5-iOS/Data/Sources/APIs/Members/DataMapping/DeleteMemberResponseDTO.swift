//
//  DeleteMemberResponseDTO.swift
//  Data
//
//  Created by 김도현 on 11/21/24.
//

import Foundation

import Domain

struct DeleteMemberResponseDTO: Decodable {
    let success: Bool
}


extension DeleteMemberResponseDTO {
    public func toDomain() -> DeleteMemberEntity {
        return .init(isSuccess: success)
    }
}
