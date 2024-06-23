//
//  ReactionSection.swift
//  App
//
//  Created by 마경미 on 22.01.24.
//

import Foundation

import Core
import Domain

import RxDataSources

struct ReactionSection {
    typealias Model = SectionModel<Int, Item>
    
    enum Item {
        case addComment(Int)
        case addReaction
        case main(EmojiEntity)
    }
}

extension ReactionSection.Item: Equatable {
    static func == (lhs: ReactionSection.Item, rhs: ReactionSection.Item) -> Bool {
        return false
    }
}

struct SelectableReactionSection {
    typealias Model = SectionModel<Int, Item>
    
    enum Item {
        case standard(Emojis)
        case realEmoji(MyRealEmojiEntity?)
    }
}

// equatable 수정하기
extension SelectableReactionSection.Item: Equatable {
    static func == (lhs: SelectableReactionSection.Item, rhs: SelectableReactionSection.Item) -> Bool {
        return false
    }
}
