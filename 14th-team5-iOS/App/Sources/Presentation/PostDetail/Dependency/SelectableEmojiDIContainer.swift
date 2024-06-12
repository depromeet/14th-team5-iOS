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

final class SelectableEmojiDIContainer {
    private func makeReactor(postId: String) -> SelectableEmojiReactor {
        return SelectableEmojiReactor(
            postId: postId,
            createReactionUseCase: makeCreateReactionUseCase(),
            createRealEmojiUseCase: makeCreateRealEmojiUseCase(),
            fetchMyRealEmojiUseCase: makeFetchMyRealEmojiUseCase())
    }
    
    func makeViewController(postId: String, subject: PublishSubject<Void>) -> SelectableEmojiViewController {
        return SelectableEmojiViewController(reactor: makeReactor(postId: postId), selectedReactionSubject: subject)
    }
}

extension SelectableEmojiDIContainer {
    private func makeRealEmojiRepository() -> RealEmojiRepositoryProtocol {
        return RealEmojiRepository()
    }
    
    private func makeCreateRealEmojiUseCase() -> CreateRealEmojiUseCaseProtocol {
        return CreateRealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
                                            
    private func makeFetchMyRealEmojiUseCase() -> FetchMyRealEmojiUseCaseProtocol {
        return FetchMyRealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
}

extension SelectableEmojiDIContainer {
    private func makeReactionRepository() -> ReactionRepositoryProtocol {
        return ReactionRepository()
    }
    
    private func makeCreateReactionUseCase() -> CreateReactionUseCaseProtocol {
        return CreateReactionUseCase(reactionRepository: makeReactionRepository())
    }
}
