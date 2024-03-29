//
//  PostCommentDeleteResponseDTO.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Foundation

import Domain

public struct PostCommentDeleteResponseDTO: Decodable {
    var success: Bool
}

extension PostCommentDeleteResponseDTO {
    func toDomain() -> PostCommentDeleteResponse {
        return .init(success: success)
    }
}
