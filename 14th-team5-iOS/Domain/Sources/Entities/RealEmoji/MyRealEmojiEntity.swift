//
//  MyRealEmoji.swift
//  Domain
//
//  Created by 마경미 on 27.01.24.
//

import Foundation

import Core

public struct MyRealEmojiEntity: Hashable {
    public let realEmojiId: String
    public let type: Emojis
    public let imageUrl: String
    
    public init(realEmojiId: String, type: Emojis, imageUrl: String) {
        self.realEmojiId = realEmojiId
        self.type = type
        self.imageUrl = imageUrl
    }
}
