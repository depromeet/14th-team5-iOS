//
//  RemoveEmojiRequest.swift
//  Domain
//
//  Created by 마경미 on 01.01.24.
//

import Foundation

public struct RemoveEmojiQuery {
    public let postId: String
}

public struct RemoveEmojiBody {
    public let content: String
}
