//
//  PostCommentResponseDTO.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Domain
import Foundation

public struct PostCommentResponseDTO: Decodable {
    let commentId: String
    let postId: String
    let memberId: String
    let comment: String
    let createdAt: String
}

extension PostCommentResponseDTO {
    func toDomain() -> PostCommentEntity {
        return .init(
            commentId: commentId,
            postId: postId,
            memberId: memberId,
            comment: comment,
            createdAt: createdAt.iso8601ToDate()
        )
    }
}
