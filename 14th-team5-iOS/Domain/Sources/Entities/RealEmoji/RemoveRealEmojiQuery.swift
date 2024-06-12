//
//  RemoveRealEmojiQuery.swift
//  Domain
//
//  Created by 마경미 on 29.01.24.
//

import Foundation

public struct RemoveRealEmojiQuery {
    public let postId: String
    public let realEmojiId: String
    
    public init(postId: String, realEmojiId: String) {
        self.postId = postId
        self.realEmojiId = realEmojiId
    }
}
