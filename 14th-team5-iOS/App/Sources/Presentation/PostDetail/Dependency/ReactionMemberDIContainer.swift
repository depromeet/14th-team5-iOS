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
    func makeFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    func makeFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeFamilyRepository())
    }
    
    func makeReactionMemberReactor(emojiData: RealEmojiEntity) -> ReactionMemberViewReactor {
        return ReactionMemberViewReactor(initialState: .init(emojiData: emojiData), familyUseCase: makeFamilyUseCase())
    }
    
    func makeViewController(emojiData: RealEmojiEntity) -> ReactionMembersViewController {
        return ReactionMembersViewController(reactor: makeReactionMemberReactor(emojiData: emojiData))
    }
}
