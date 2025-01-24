//
//  AddEmojiRequest.swift
//  Domain
//
//  Created by 마경미 on 01.01.24.
//

import Foundation

public struct CreateReactionRequest {
    public let emojiId: String
    
    public init(content: String) {
        self.emojiId = content
    }
}
