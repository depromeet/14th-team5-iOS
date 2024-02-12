//
//  EmojiSectionModel.swift
//  App
//
//  Created by Kim dohyun on 1/23/24.
//

import Foundation

import RxDataSources

public enum EmojiSectionType: String, Equatable {
    case realEmoji
}


public enum EmojiSectionModel: SectionModelType {
    case realEmoji([EmojiSectionItem])
    
    public var items: [EmojiSectionItem] {
        switch self {
        case let .realEmoji(items): return items
        }
        
    }
    
    public init(original: EmojiSectionModel, items: [EmojiSectionItem]) {
        switch original {
        case .realEmoji: self = .realEmoji(items)
        }
    }
    
    public func getSectionType() -> EmojiSectionType {
        switch self {
        case .realEmoji: return .realEmoji
        }
    }
    
}


public enum EmojiSectionItem {
    case realEmojiItem(BibbiRealEmojiCellReactor)
}
