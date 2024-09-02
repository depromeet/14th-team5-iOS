//
//  RemoveEmojiRequest.swift
//  Domain
//
//  Created by 마경미 on 01.01.24.
//

import Foundation
import Core

public struct RemoveReactionRequest {
    public let content: Emojis
    
    public init(content: Emojis) {
        self.content = content
    }
}
