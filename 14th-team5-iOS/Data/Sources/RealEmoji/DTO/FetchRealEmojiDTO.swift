//
//  FetchRealEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 22.01.24.
//

import Foundation

import Core
import Domain

public struct FetchRealEmojiListParameter: Codable {
    let postId: String
}

public struct FetchRealEmojiListResponseDTO: Codable {
    let results: [RealEmojiDTO]
    
    func toDomain() -> [FetchedEmojiData]? {
        let myMemberId = FamilyUserDefaults.returnMyMemberId()
        let groupedByEmojiType = Dictionary(grouping: results, by: { $0.realEmojiId })

        let fetchedEmojiDataArray = groupedByEmojiType.map { (emojiType, responses) in
            guard let minReactionIdResponse = responses.min(by: { $0.postRealEmojiId < $1.postRealEmojiId }) else {
                return FetchedEmojiData(isStandard: false, isSelfSelected: false, postEmojiId: "", emojiType: .emoji1, count: 0, realEmojiId: "", realEmojiImageURL: "", memberIds: [])
            }
            
            let selfSelected = responses.contains { $0.memberId == myMemberId }
            let count = responses.count

            return FetchedEmojiData(
                isStandard: false,
                isSelfSelected: selfSelected,
                postEmojiId: minReactionIdResponse.postRealEmojiId,
                emojiType: Emojis.emoji(forString: minReactionIdResponse.emojiType),
                count: count,
                realEmojiId: emojiType,
                realEmojiImageURL: minReactionIdResponse.emojiImageUrl,
                memberIds: responses.map { $0.memberId }
            )
        }

        return fetchedEmojiDataArray
    }
}

public struct RealEmojiDTO: Codable {
    let postRealEmojiId: String
    let postId: String
    let memberId: String
    let realEmojiId: String
    let emojiImageUrl: String
    let emojiType: String
}
