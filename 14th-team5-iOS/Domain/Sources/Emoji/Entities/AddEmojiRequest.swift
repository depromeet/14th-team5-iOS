//
//  AddEmojiRequest.swift
//  Domain
//
//  Created by 마경미 on 01.01.24.
//

import Foundation
import Core

public struct AddEmojiQuery {
    public let postId: String
    
    public init(postId: String) {
        self.postId = postId
    }
}

public struct AddEmojiBody {
    public let emojiId: String
    
    public init(content: String) {
        self.emojiId = content
    }
}
