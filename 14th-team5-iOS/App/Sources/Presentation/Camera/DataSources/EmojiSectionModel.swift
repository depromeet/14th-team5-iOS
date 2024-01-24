//
//  EmojiSectionModel.swift
//  App
//
//  Created by Kim dohyun on 1/23/24.
//

import Foundation

import RxDataSources

public enum EmojiSectionType: String, Equatable {
    case emoji
    case realEmoji
}


public enum EmojiSectionModel: SectionModelType {
    case emoji([EmojiSectionItem])
    case realEmoji([EmojiSectionItem])
    
    public var items: [EmojiSectionItem] {
        switch self {
        case let .emoji(items): return items
        case let .realEmoji(items): return items
        }
        
    }
    
    public init(original: EmojiSectionModel, items: [EmojiSectionItem]) {
        switch original {
        case .emoji: self = .emoji(items)
        case .realEmoji: self = .realEmoji(items)
        }
    }
    
    public func getSectionType() -> EmojiSectionType {
        switch self {
        case .emoji: return .emoji
        case .realEmoji: return .realEmoji
        }
    }
    
}


public enum EmojiSectionItem {
    case emojiItem(BibbiEmojiCellReactor)
    case realEmojiItem(BibbiRealEmojiCellReactor)
}
