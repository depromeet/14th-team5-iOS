//
//  PostResponseDTO.swift
//  Data
//
//  Created by Kim dohyun on 6/6/24.
//

import Foundation
import Domain

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
