//
//  FetchEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 03.01.24.
//

import Foundation

import Core
import Domain

public struct FetchEmojiRequestDTO: Codable {
    let postId: String
}

struct FetchEmojiResponse: Codable {
    let reactionId: String
    let postId: String
    let memberId: String
    let emojiType: String
    
    private func containsCurrentUser(memberIds: [String]) -> Bool {
        let currentMemberId = FamilyUserDefaults.returnMyMemberId()
        return memberIds.contains(currentMemberId)
    }
}

struct FetchEmojiResponseDTO: Codable {
    let results: [FetchEmojiResponse]
    
    func toDomain() -> [FetchedEmojiData] {
        let myMemberId = FamilyUserDefaults.returnMyMemberId()
        let groupedByEmojiType = Dictionary(grouping: results, by: { $0.emojiType })

        let fetchedEmojiDataArray = groupedByEmojiType.map { (emojiType, responses) in
            guard let minReactionIdResponse = responses.min(by: { $0.reactionId < $1.reactionId }) else {
                return FetchedEmojiData(isStandard: true, isSelfSelected: false, postEmojiId: "", emojiType: .emoji1, count: 0, realEmojiId: "", realEmojiImageURL: "")
            }
            
            let selfSelected = responses.contains { $0.memberId == myMemberId }

            let count = responses.count

            return FetchedEmojiData(
                isStandard: true,
                isSelfSelected: selfSelected,
                postEmojiId: minReactionIdResponse.reactionId,
                emojiType: Emojis.emoji(forString: emojiType),
                count: count,
                realEmojiId: "",
                realEmojiImageURL: ""
            )
        }
        
        return fetchedEmojiDataArray
    }
}
