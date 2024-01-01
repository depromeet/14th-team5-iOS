//
//  Emojis.swift
//  App
//
//  Created by 마경미 on 14.12.23.
//

import UIKit
import DesignSystem

public enum Emojis: Int {
    case emoji1 = 1
    case emoji2 = 2
    case emoji3 = 3
    case emoji4 = 4
    case emoji5 = 5
    
    public var emojiImage: UIImage {
        switch self {
        case .emoji1:
            return DesignSystemAsset.emoji1.image
        case .emoji2:
            return DesignSystemAsset.emoji2.image
        case .emoji3:
            return DesignSystemAsset.emoji3.image
        case .emoji4:
            return DesignSystemAsset.emoji4.image
        case .emoji5:
            return DesignSystemAsset.emoji5.image
        }
    }
    
    public var emojiString: String {
        switch self {
        case .emoji1:
            return "Emoji_1"
        case .emoji2:
            return "Emoji_2"
        case .emoji3:
            return "Emoji_3"
        case .emoji4:
            return "Emoji_4"
        case .emoji5:
            return "Emoji_5"
        }
    }
    
    public var emojiIndex: Int {
        return self.rawValue
    }
    
    public static var allEmojis: [Emojis] {
        return [.emoji1, .emoji2, .emoji3, .emoji4, .emoji5]
    }
    
    public static func emoji(forIndex index: Int) -> Emojis {
        return Emojis(rawValue: index) ?? .emoji1
    }
}
