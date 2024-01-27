//
//  CameraRealEmojiItems.swift
//  Domain
//
//  Created by Kim dohyun on 1/24/24.
//

import Foundation


public enum CameraRealEmojiItems: String, CaseIterable {
    case emoji1 = "emoji1"
    case emoji2 = "emoji2"
    case emoji3 = "emoji3"
    case emoji4 = "emoji4"
    case emoji5 = "emoji5"
    
    public var emojiType: String {
        switch self {
        case .emoji1:
            return "emoji_1"
        case .emoji2:
            return "emoji_2"
        case .emoji3:
            return "emoji_3"
        case .emoji4:
            return "emoji_4"
        case .emoji5:
            return "emoji_5"
        }
    }
    
}
