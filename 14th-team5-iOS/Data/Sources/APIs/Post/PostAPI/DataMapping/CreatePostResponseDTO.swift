//
//  CreatePostResponseDTO.swift
//  Data
//
//  Created by 김도현 on 11/22/24.
//

import Foundation

import Domain


struct CreatePostResponseDTO: Decodable {
    let postId: String?
    let authorId: String?
    let type: String?
    let missionId: String?
    let commentCount: Int?
    let emojiCount: Int?
    let imageUrl: String?
    let content: String?
    let createdAt: String
}


extension CreatePostResponseDTO {
    public func toDomain() -> CreatePostEntity {
        return .init(
            postId: postId ?? "",
            authorId: authorId ?? "",
            commentCount: commentCount ?? 0,
            missionType: type ?? "SURVIVAL",
            missionId: missionId ?? "",
            emojiCount: emojiCount ?? 0,
            imageURL: imageUrl ?? "",
            content: content ?? "",
            createdAt: createdAt
        )
    }
}
