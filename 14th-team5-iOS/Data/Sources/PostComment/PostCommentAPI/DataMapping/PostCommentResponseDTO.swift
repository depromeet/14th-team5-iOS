//
//  PostCommentResponseDTO.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Foundation

import Domain

public struct PostCommentResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case commentId
        case postId
        case memberId
        case comment
        case createdAt
    }
    var commentId: String
    var postId: String
    var memberId: String
    var comment: String
    var createdAt: String
}

extension PostCommentResponseDTO {
    func toDomain() -> PostCommentResponse {
        return .init(
            commentId: commentId,
            postId: postId,
            memberId: memberId,
            comment: comment,
            createdAt: createdAt.iso8601ToDate()
        )
    }
}
