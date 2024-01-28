//
//  FetchRealEmojiData.swift
//  Domain
//
//  Created by 마경미 on 22.01.24.
//

import Foundation

public struct FetchRealEmojiData {
    let memberId: String
    let realEmojiId: String
    let emojiImageUrl: String
    
    public init(memberId: String, realEmojiId: String, emojiImageUrl: String) {
        self.memberId = memberId
        self.realEmojiId = realEmojiId
        self.emojiImageUrl = emojiImageUrl
    }
}
