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
    let voiceURL: String?
    let commentType: String
    let comment: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case commentId, postId, memberId
        case comment
        case voiceURL = "voiceUrl"
        case createdAt
        case commentType = "type"
    }
}

extension PostCommentResponseDTO {
    enum CommentType: String, Decodable {
        case text = "TEXT"
        case voice = "VOICE"
    }
}

extension PostCommentResponseDTO {
    func toDomain() -> PostCommentEntity {
        return .init(
            commentId: commentId,
            postId: postId,
            memberId: memberId,
            comment: comment,
            voiceURL: voiceURL,
            createdAt: createdAt.iso8601ToDate(),
            commentType: commentType
        )
    }
}
