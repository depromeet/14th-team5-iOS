//
//  DeleteVoiceCommentResponseDTO.swift
//  Data
//
//  Created by 김도현 on 1/7/25.
//

import Foundation

import Domain

struct DeleteVoiceCommentResponseDTO: Decodable {
    let success: Bool
}

extension DeleteVoiceCommentResponseDTO {
    func toDomain() -> DeleteVoiceCommentEntity {
        return .init(success: success)
    }
}
