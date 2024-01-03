//
//  FetchEmojiData.swift
//  Domain
//
//  Created by 마경미 on 03.01.24.
//

import Foundation

public struct FetchEmojiData {
    let memberId: String
    let isMe: Bool
    let emojiType: String
    
    public init(memberId: String, isMe: Bool, emojiType: String) {
        self.memberId = memberId
        self.isMe = isMe
        self.emojiType = emojiType
    }
}

public struct FetchEmojiList {
    let reactions: [FetchEmojiData]
    
    public init(reactions: [FetchEmojiData]) {
        self.reactions = reactions
    }
}
