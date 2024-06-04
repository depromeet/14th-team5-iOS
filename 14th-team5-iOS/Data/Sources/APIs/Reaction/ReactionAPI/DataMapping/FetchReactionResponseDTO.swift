//
//  FetchEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 03.01.24.
//

import Foundation

import Core
import Domain

struct FetchReactionResult: Codable {
    let reactionId: String
    let postId: String
    let memberId: String
    let emojiType: String
    
    private func containsCurrentUser(memberIds: [String]) -> Bool {
        let currentMemberId = FamilyUserDefaults.returnMyMemberId()
        return memberIds.contains(currentMemberId)
    }
}

struct FetchReactionResponseDTO: Codable {
    let results: [FetchReactionResult]
    
    func toDomain() -> [FetchedEmojiData] {
        let myMemberId = FamilyUserDefaults.returnMyMemberId()
        let groupedByEmojiType = Dictionary(grouping: results, by: { $0.emojiType })

        let fetchedEmojiDataArray = groupedByEmojiType.map { (emojiType, responses) in
            guard let minReactionIdResponse = responses.min(by: { $0.reactionId < $1.reactionId }) else {
                return FetchedEmojiData(isStandard: true, isSelfSelected: false, postEmojiId: "", emojiType: .emoji1, count: 0, realEmojiId: "", realEmojiImageURL: "", memberIds: [])
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
                realEmojiImageURL: "",
                memberIds: responses.map { $0.memberId }
            )
        }
        
        return fetchedEmojiDataArray
    }
}
