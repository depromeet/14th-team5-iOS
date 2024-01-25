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
            return "EMOJI_1"
        case .emoji2:
            return "EMOJI_2"
        case .emoji3:
            return "EMOJI_3"
        case .emoji4:
            return "EMOJI_4"
        case .emoji5:
            return "EMOJI_5"
        }
    }
    
}
