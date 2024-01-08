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

final class ReactionDIContainer {
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    func makeFamilyRepository() -> SearchFamilyRepository {
        return FamilyAPIs.Worker()
    }
    
    func makeFamilyUseCase() -> SearchFamilyUseCase {
        return SearchFamilyUseCase(searchFamilyRepository: makeFamilyRepository())
    }
    
    func makeReactionMemberReactor(memberIds: [String]) -> ReactionMemberReactor {
        return ReactionMemberReactor(initialState: .init(reactionMemberIds: memberIds), familyRepository: makeFamilyUseCase())
    }
    
    func makeViewController(memberIds: [String]) -> ReactionMembersViewController {
        return ReactionMembersViewController(reactor: makeReactionMemberReactor(memberIds: memberIds))
    }
    
    func makeEmojiRepository() -> EmojiRepository {
        return EmojiAPIs.Worker()
    }
    
    func makeEmojiUseCase() -> EmojiUseCaseProtocol {
        return EmojiUseCase(emojiRepository: makeEmojiRepository())
    }
    
    func makeReactor(type: EmojiReactor.CellType = .home, post: PostListData) -> EmojiReactor {
        return EmojiReactor(
            provider: globalState,
            emojiRepository: makeEmojiUseCase(),
            initialState: .init(type: type, post: post)
        )
    }
}
