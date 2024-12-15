//
//  PostDetailResponseDTO.swift
//  Data
//
//  Created by 김도현 on 11/19/24.
//

import Foundation

import Domain

struct PostDetailResponseDTO: Decodable {
    let postId: String
    let authorId: String
    let type: String
    let missionId: String?
    let commentCount: Int
    let emojiCount: Int
    let imageUrl: String
    let content: String
    let createdAt: String
}


extension PostDetailResponseDTO {
    func toDomain() -> PostDetailEntity {
        return .init(
            postId: postId,
            authorId: authorId,
            type: PostType(rawValue: type) ?? .survival,
            missionId: missionId,
            commentCount: commentCount,
            emojiCount: emojiCount,
            imageUrl: imageUrl,
            content: content,
            createdAt: createdAt
        )
    }
}
