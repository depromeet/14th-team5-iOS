//
//  FetchEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 03.01.24.
//

import Foundation
import Domain

public struct FetchEmojiRequestDTO: Codable {
    let postId: String
}

struct FetchEmojiResponse: Codable {
    let reactionId: String
    let postId: String
    let memberId: String
    let emojiType: String
    
    func toDomain() -> FetchEmojiData {
        return .init(memberId: memberId, isMe: FamilyUserDefaults.checkIsMyMemberId(memberId: memberId), emojiType: emojiType)
    }
}

struct FetchEmojiResponseDTO: Codable {
    let results: [FetchEmojiResponse]
    
    func toDomain() -> FetchEmojiList {
        return .init(reactions: results.map { $0.toDomain()})
    }
}
