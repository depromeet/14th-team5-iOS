//
//  PostCommentDeleteResponseDTO.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Domain
import Foundation

public struct DeletePostCommentResponseDTO: Decodable {
    let success: Bool
}

extension DeletePostCommentResponseDTO {
    func toDomain() -> PostCommentDeleteEntity {
        return .init(success: success)
    }
}
