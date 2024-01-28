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

final class SelectableEmojiDIContainer {
    private func makeReactor() -> SelectableEmojiReactor {
        return SelectableEmojiReactor(emojiRepository: makeEmojiUseCase(), realEmojiRepository: makeRealEmojiUseCase())
    }
    
    func makeViewController() -> SelectableEmojiViewController {
        return SelectableEmojiViewController(reactor: makeReactor())
    }
}

extension SelectableEmojiDIContainer {
    private func makeRealEmojiRepository() -> RealEmojiRepository {
        return RealEmojiAPIWorker()
    }
    
    private func makeRealEmojiUseCase() -> RealEmojiUseCaseProtocol {
        return RealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
}

extension SelectableEmojiDIContainer {
    private func makeEmojiRepository() -> EmojiRepository {
        return EmojiAPIWorker()
    }
    
    private func makeEmojiUseCase() -> EmojiUseCaseProtocol {
        return EmojiUseCase(emojiRepository: makeEmojiRepository())
    }
}
