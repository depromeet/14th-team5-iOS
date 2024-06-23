//
//  FetchRealEmojiData.swift
//  Domain
//
//  Created by 마경미 on 22.01.24.
//

import Foundation
import Core

public struct EmojiEntity {
    public let isStandard: Bool
    public var isSelfSelected: Bool
    public let postEmojiId: String
    public let emojiType: Emojis
    public var count: Int
    public let realEmojiId: String
    public let realEmojiImageURL: String
    public var memberIds: [String]
    
    public init(isStandard: Bool, isSelfSelected: Bool, postEmojiId: String, emojiType: Emojis, count: Int, realEmojiId: String, realEmojiImageURL: String, memberIds: [String]) {
        self.isStandard = isStandard
        self.isSelfSelected = isSelfSelected
        self.postEmojiId = postEmojiId
        self.emojiType = emojiType
        self.count = count
        self.realEmojiId = realEmojiId
        self.realEmojiImageURL = realEmojiImageURL
        self.memberIds = memberIds
    }
}
