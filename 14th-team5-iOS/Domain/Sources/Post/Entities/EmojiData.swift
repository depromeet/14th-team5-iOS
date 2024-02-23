//
//  EmojiData.swift
//  Domain
//
//  Created by 마경미 on 30.12.23.
//

import Foundation
import Core

public struct EmojiData {
    public let emoji: Emojis
    public var count: Int
    
    public init(emoji: Emojis, count: Int) {
        self.emoji = emoji
        self.count = count
    }
}
