//
//  ReactionDIContainer.swift
//  App
//
//  Created by 마경미 on 28.01.24.
//

import Foundation

import Data
import Domain

final class ReactionDIContainer {
    private func makeReactor(postId: String) -> TempReactor {
        return TempReactor(initialState: .init(postId: postId), emojiRepository: makeEmojiUseCase(), realEmojiRepository: makeRealEmojiUseCase())
    }
    
    func makeViewController(postId: String) -> ReactionViewController {
        return ReactionViewController(reactor: makeReactor(postId: postId))
    }
}

extension ReactionDIContainer {
    private func makeRealEmojiRepository() -> RealEmojiRepository {
        return RealEmojiAPIWorker()
    }
    
    private func makeRealEmojiUseCase() -> RealEmojiUseCaseProtocol {
        return RealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
}

extension ReactionDIContainer {
    private func makeEmojiRepository() -> EmojiRepository {
        return EmojiAPIWorker()
    }
    
    private func makeEmojiUseCase() -> EmojiUseCaseProtocol {
        return EmojiUseCase(emojiRepository: makeEmojiRepository())
    }
}
