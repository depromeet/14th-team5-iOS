//
//  PostDTO.swift
//  Data
//
//  Created by 마경미 on 30.12.23.
//

import Foundation
import Domain

public struct PostRequestDTO: Codable {
    let postId: String
}

extension PostRequestDTO {
    func toDomain() -> PostQuery {
        return .init(postId: postId)
    }
}

struct PostResponseDTO: Codable {
    let postId: String
    let authorId: String
    let commentCount: Int
    let emojiCount: Int
    let imageUrl: String
    let content: String
    let createdAt: String
}

extension PostResponseDTO {
    func toDomain() -> PostData {
        let writer = FamilyUserDefaults.load(memberId: authorId)
        
        return .init(writer: writer, time: createdAt, imageURL: imageUrl, imageText: content, emojis: [])
    }
}
