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
        return SelectableEmojiReactor(postId: postId, emojiRepository: makeEmojiUseCase(), realEmojiRepository: makeRealEmojiUseCase())
    }
    
    func makeViewController(postId: String, subject: PublishSubject<Void>) -> SelectableEmojiViewController {
        return SelectableEmojiViewController(reactor: makeReactor(postId: postId), selectedReactionSubject: subject)
    }
}

extension SelectableEmojiDIContainer {
    private func makeRealEmojiRepository() -> RealEmojiRepositoryProtocol {
        return RealEmojiAPIWorker()
    }
    
    private func makeRealEmojiUseCase() -> RealEmojiUseCaseProtocol {
        return RealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
}

extension SelectableEmojiDIContainer {
    private func makeEmojiRepository() -> ReactionRepositoryProtocol {
        return ReactionAPIWorker()
    }
    
    private func makeEmojiUseCase() -> EmojiUseCaseProtocol {
        return EmojiUseCase(emojiRepository: makeEmojiRepository())
    }
}
