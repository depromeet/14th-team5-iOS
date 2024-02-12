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
    
    func makeReactionMemberReactor(memberIds: [String], type: Emojis) -> ReactionMemberReactor {
        return ReactionMemberReactor(initialState: .init(reactionMemberIds: memberIds, reactionMemberType: type), familyRepository: makeFamilyUseCase())
    }
    
    func makeViewController(memberIds: [String], type: Emojis) -> ReactionMembersViewController {
        return ReactionMembersViewController(reactor: makeReactionMemberReactor(memberIds: memberIds, type: type))
    }
    
    func makeEmojiRepository() -> EmojiRepository {
        return EmojiAPIs.Worker()
    }
    
    func makeEmojiUseCase() -> EmojiUseCaseProtocol {
        return EmojiUseCase(emojiRepository: makeEmojiRepository())
    }
    
    func makeMemberRepository() -> MemberRepositoryProtocol {
        return MemberRepository()
    }
    
    func makeMemberUseCase() -> MemberUseCaseProtocol {
        return MemberUseCase(memberRepository: makeMemberRepository())
    }
    
    func makeReactor(type: EmojiReactor.CellType = .home, post: PostListData) -> EmojiReactor {
        return EmojiReactor(
            provider: globalState,
            memberUserCase: makeMemberUseCase(),
            emojiRepository: makeEmojiUseCase(),
            initialState: .init(type: type, post: post)
        )
    }
}
