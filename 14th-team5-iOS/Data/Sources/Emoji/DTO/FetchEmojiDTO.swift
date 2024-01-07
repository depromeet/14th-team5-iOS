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
    let emoji_1: [String]
    let emoji_2: [String]
    let emoji_3: [String]
    let emoji_4: [String]
    let emoji_5: [String]
    
    func toDomain() -> [FetchEmojiData] {
        let emojis_memberIds: [FetchEmojiData] = [
            FetchEmojiData(isSelfSelected: containsCurrentUser(memberIds: emoji_1), count: emoji_1.count, memberIds: emoji_1),
            FetchEmojiData(isSelfSelected: containsCurrentUser(memberIds: emoji_2), count: emoji_2.count, memberIds: emoji_2),
            FetchEmojiData(isSelfSelected: containsCurrentUser(memberIds: emoji_3), count: emoji_3.count, memberIds: emoji_3),
            FetchEmojiData(isSelfSelected: containsCurrentUser(memberIds: emoji_4), count: emoji_4.count, memberIds: emoji_4),
            FetchEmojiData(isSelfSelected: containsCurrentUser(memberIds: emoji_5), count: emoji_5.count, memberIds: emoji_5)
        ]
        
        return emojis_memberIds
    }

    private func containsCurrentUser(memberIds: [String]) -> Bool {
//        let currentMemberId = FamilyUserDefaults.returnMyMemberId()
        let currentMemberId = "01HJBNWZGNP1KJNMKWVZJ039HY"
        return memberIds.contains(currentMemberId)
    }
}

struct FetchEmojiResponseDTO: Codable {
    let emojiMemberIdsList: FetchEmojiResponse
    
    func toDomain() -> FetchEmojiDataList {
        return .init(emojis_memberIds: emojiMemberIdsList.toDomain())
    }
}
