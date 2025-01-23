//
//  Emojis.swift
//  App
//
//  Created by 마경미 on 14.12.23.
//

import UIKit
import DesignSystem

// TODO: - 요거 옮겨주세요~
public enum Emojis: Int {
    case emoji1 = 1
    case emoji2 = 2
    case emoji3 = 3
    case emoji4 = 4
    case emoji5 = 5
    
    public static func getEmojiImage(index: Int) -> UIImage {
        switch index {
        case 1:
            return DesignSystemAsset.emoji1.image
        case 2:
            return DesignSystemAsset.emoji2.image
        case 3:
            return DesignSystemAsset.emoji3.image
        case 4:
            return DesignSystemAsset.emoji4.image
        case 5:
            return DesignSystemAsset.emoji5.image
        default:
            return DesignSystemAsset.emoji1.image
        }
    }
    
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
    
    public var emojiBadgeImage: UIImage {
        switch self {
        case .emoji1:
            return DesignSystemAsset.emojipoint1.image
        case .emoji2:
            return DesignSystemAsset.emojipoint2.image
        case .emoji3:
            return DesignSystemAsset.emojipoint3.image
        case .emoji4:
            return DesignSystemAsset.emojipoint4.image
        case .emoji5:
            return DesignSystemAsset.emojipoint5.image
        }
    }
    
    public var emojiString: String {
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
    
    public var emojiIndex: Int {
        return self.rawValue
    }
    
    public static var allEmojis: [Emojis] {
        return [.emoji1, .emoji2, .emoji3, .emoji4, .emoji5]
    }
    
    public static func emoji(forIndex index: Int) -> Emojis {
        return Emojis(rawValue: index) ?? .emoji1
    }
    
    public static func emoji(forString name: String) -> Emojis {
        switch name {
        case "EMOJI_1", "emoji_1": return .emoji1
        case "EMOJI_2", "emoji_2": return .emoji2
        case "EMOJI_3", "emoji_3": return .emoji3
        case "EMOJI_4", "emoji_4": return .emoji4
        case "EMOJI_5", "emoji_5": return .emoji5
        default: return .emoji1
        }
    }
}
