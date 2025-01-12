//
//  ReactionMembersViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Core
import Domain
import Foundation
import MacrosInterface

@Wrapper<ReactionMemberViewReactor, ReactionMembersViewController>
final class ReactionMembersViewControllerWrapper {
    
    private let emojiData: EmojiEntity
    
    init(emojiData: EmojiEntity) {
        self.emojiData = emojiData
    }
    
    func makeReactor() -> R {
        return ReactionMemberViewReactor(initialState: .init(emojiData: emojiData))
    }
    
}
