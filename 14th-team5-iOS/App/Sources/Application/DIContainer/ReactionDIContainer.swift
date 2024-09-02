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
    private let repository: ReactionRepositoryProtocol = ReactionRepository()
    
    private func makeCreateReactionUseCase() -> CreateReactionUseCaseProtocol {
        return CreateReactionUseCase(reactionRepository: repository)
    }
    
    private func makeRemoveReactionUseCase() -> RemoveReactionUseCaseProtocol {
        return RemoveReactionUseCase(reactionRepository: repository)
    }
    
    private func makeFetchReactionListUseCase() -> FetchReactionListUseCaseProtocol {
        return FetchReactionListUseCase(reactionRepository: repository)
    }
}

extension ReactionDIContainer {
    func registerDependencies() {
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
