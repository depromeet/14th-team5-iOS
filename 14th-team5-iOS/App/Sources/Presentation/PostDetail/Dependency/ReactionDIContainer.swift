//
//  ReactionDIContainer.swift
//  App
//
//  Created by 마경미 on 28.01.24.
//

import Core
import Data
import Domain
import UIKit

enum ReactionType {
    case post
    case calendar
}

final class ReactionDIContainer {
    var type: ReactionType
    
    init(type: ReactionType) {
        self.type = type
    }
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    private func makeReactor(post: PostEntity) -> ReactionViewReactor {
        return ReactionViewReactor(
            initialState: .init(type: type, postListData: post),
            provider: globalState,
            fetchReactionUseCase: makeFetchReactionListUseCase(),
            createReactionUseCase: makeCreateReactionUseCase(),
            removeReactionUseCase: makeRemoveReactionUseCase(),
            fetchRealEmojiListUseCase: makeFetchRealEmojiListUseCase(),
            createRealEmojiUseCase: makeCreateRealEmojiUseCase(),
            removeRealEmojiUseCase: makeRemoveRealEmojiUseCase())
    }
    
    func makeViewController(post: PostEntity) -> ReactionViewController {
        return ReactionViewController(reactor: makeReactor(post: post))
    }
}

extension ReactionDIContainer {
    private func makeRealEmojiRepository() -> RealEmojiRepositoryProtocol {
        return RealEmojiRepository()
    }
    
    private func makeCreateRealEmojiUseCase() -> CreateRealEmojiUseCaseProtocol {
        return CreateRealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
    
    private func makeRemoveRealEmojiUseCase() -> RemoveRealEmojiUseCaseProtocol {
        return RemoveRealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
    
    private func makeFetchRealEmojiListUseCase() -> FetchRealEmojiListUseCaseProtocol {
        return FetchRealEmojiListUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
}

extension ReactionDIContainer {
    private func makeReactionRepository() -> ReactionRepositoryProtocol {
        return ReactionRepository()
    }
    
    private func makeCreateReactionUseCase() -> CreateReactionUseCaseProtocol {
        return CreateReactionUseCase(reactionRepository: makeReactionRepository())
    }
    
    private func makeRemoveReactionUseCase() -> RemoveReactionUseCaseProtocol {
        return RemoveReactionUseCase(reactionRepository: makeReactionRepository())
    }
    
    private func makeFetchReactionListUseCase() -> FetchReactionListUseCaseProtocol {
        return FetchReactionListUseCase(reactionRepository: makeReactionRepository())
    }
}
