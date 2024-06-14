//
//  FetchRealEmojiQuery.swift
//  Domain
//
//  Created by 마경미 on 22.01.24.
//

import Foundation

public struct FetchRealEmojiQuery {
    public let postId: String
    
    public init(postId: String) {
        self.postId = postId
    }
}
