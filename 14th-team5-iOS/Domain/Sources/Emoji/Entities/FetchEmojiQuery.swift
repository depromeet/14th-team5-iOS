//
//  FetchEmojiQuery.swift
//  Domain
//
//  Created by 마경미 on 03.01.24.
//

import Foundation

public struct FetchEmojiQuery {
    public let postId: String
    
    public init(postId: String) {
        self.postId = postId
    }
}
