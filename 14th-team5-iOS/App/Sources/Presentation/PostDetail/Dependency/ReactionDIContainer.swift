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

final class ReactionDIContainer: BaseContainer {
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

extension ReactionDIContainer {
    func registerDependencies() {
        container.register(type: CreateRealEmojiUseCaseProtocol.self) { _ in
            self.makeCreateRealEmojiUseCase()
        }
        
        container.register(type: RemoveRealEmojiUseCaseProtocol.self) { _ in
            self.makeRemoveRealEmojiUseCase()
        }
        
        container.register(type: FetchRealEmojiListUseCaseProtocol.self) { _ in
            self.makeFetchRealEmojiListUseCase()
        }
        
        container.register(type: CreateReactionUseCaseProtocol.self) { _ in
            self.makeCreateReactionUseCase()
        }
        
        container.register(type: RemoveReactionUseCaseProtocol.self) { _ in
            self.makeRemoveReactionUseCase()
        }
        
        container.register(type: FetchReactionListUseCaseProtocol.self) { _ in
            self.makeFetchReactionListUseCase()
        }
    }
}
