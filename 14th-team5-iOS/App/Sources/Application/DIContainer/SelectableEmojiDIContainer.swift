//
//  ReactionsDIContainer.swift
//  App
//
//  Created by 마경미 on 06.01.24.
//

import UIKit

import Core
import Data
import Domain

import RxSwift

final class SelectableEmojiDIContainer: BaseContainer {
    private func makeRealEmojiRepository() -> RealEmojiRepositoryProtocol {
        return RealEmojiRepository()
    }
    
    private func makeCreateRealEmojiUseCase() -> CreateRealEmojiUseCaseProtocol {
        return CreateRealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
                                            
    private func makeFetchMyRealEmojiUseCase() -> FetchMyRealEmojiUseCaseProtocol {
        return FetchMyRealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
    
    private func makeReactionRepository() -> ReactionRepositoryProtocol {
        return ReactionRepository()
    }
    
    private func makeCreateReactionUseCase() -> CreateReactionUseCaseProtocol {
        return CreateReactionUseCase(reactionRepository: makeReactionRepository())
    }
}

extension SelectableEmojiDIContainer {
    func registerDependencies() {
        container.register(type: CreateRealEmojiUseCaseProtocol.self) { _ in
            self.makeCreateRealEmojiUseCase()
        }
        
        container.register(type: FetchMyRealEmojiUseCaseProtocol.self) { _ in
            self.makeFetchMyRealEmojiUseCase()
        }
        
        container.register(type: CreateReactionUseCaseProtocol.self) { _ in
            self.makeCreateReactionUseCase()
        }
    }
}
