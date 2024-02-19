//
//  ReactionDIContainer.swift
//  App
//
//  Created by 마경미 on 07.01.24.
//

import UIKit

import Core
import Data
import Domain

import RxDataSources

final class ReactionMemberDIContainer {
    func makeFamilyRepository() -> SearchFamilyRepository {
        return FamilyAPIs.Worker()
    }
    
    func makeFamilyUseCase() -> SearchFamilyUseCase {
        return SearchFamilyUseCase(searchFamilyRepository: makeFamilyRepository())
    }
    
    func makeReactionMemberReactor(emojiData: FetchedEmojiData) -> ReactionMemberViewReactor {
        return ReactionMemberViewReactor(initialState: .init(emojiData: emojiData), familyRepository: makeFamilyUseCase())
    }
    
    func makeViewController(emojiData: FetchedEmojiData) -> ReactionMembersViewController {
        return ReactionMembersViewController(reactor: makeReactionMemberReactor(emojiData: emojiData))
    }
}
