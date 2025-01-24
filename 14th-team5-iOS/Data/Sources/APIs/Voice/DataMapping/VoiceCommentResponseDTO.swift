//
//  VoiceCommentResponseDTO.swift
//  Data
//
//  Created by 김도현 on 1/7/25.
//

import Foundation

import Domain


struct VoiceCommentResponseDTO: Decodable {
    let commentId: String
    let type: String
    let postId: String
    let memberId: String
    let comment: String
    let createdAt: String
}



extension VoiceCommentResponseDTO {
    func toDomain() -> VoiceCommentEntity {
        return .init(
            commentId: commentId,
            type: CommentType(rawValue: type) ?? .voice,
            postId: postId,
            memberId: memberId,
            comment: comment,
            createdAt: createdAt
        )
    }
}
