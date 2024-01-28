//
//  FetchRealEmojiDTO.swift
//  Data
//
//  Created by 마경미 on 22.01.24.
//

import Foundation

import Domain

public struct FetchRealEmojiListParameter: Codable {
    let postId: String
}

public struct FetchRealEmojiListResponseDTO: Codable {
    let results: [RealEmojiDTO]
    
    public func toDomain() -> [FetchRealEmojiData]? {
        return results.map { $0.toDomain() }
    }
}

public struct RealEmojiDTO: Codable {
    let postRealEmojiId: String
    let postId: String
    let memberId: String
    let realEmojiId: String
    let emojiImageUrl: String
    
    func toDomain() -> FetchRealEmojiData {
        return .init(memberId: memberId, realEmojiId: realEmojiId, emojiImageUrl: emojiImageUrl)
    }
}
