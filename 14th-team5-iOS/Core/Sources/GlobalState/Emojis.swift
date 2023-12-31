//
//  Emojis.swift
//  App
//
//  Created by 마경미 on 14.12.23.
//

import UIKit
import DesignSystem

public enum Emojis: Int {
    case emoji1 = 0
    case emoji2 = 1
    case emoji3 = 2
    case emoji4 = 3
    case emoji5 = 4
    
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
