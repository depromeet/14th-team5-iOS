//
//  ReactionMembersViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Foundation

import Core
import Domain

final class ReactionMembersViewControllerWrapper: BaseWrapper {
    typealias R = ReactionMemberViewReactor
    typealias V = ReactionMembersViewController
    
    private let emojiData: EmojiEntity
    
    init(emojiData: EmojiEntity) {
        self.emojiData = emojiData
    }
    
    func makeViewController() -> V {
        return ReactionMembersViewController(reactor: makeReactor())
    }
    
    func makeReactor() -> R {
        return ReactionMemberViewReactor(initialState: .init(emojiData: emojiData))
    }
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
}
