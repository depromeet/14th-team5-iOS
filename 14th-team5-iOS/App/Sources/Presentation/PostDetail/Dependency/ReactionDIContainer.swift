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

final class ReactionDIContainer {
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    private func makeReactor(post: PostListData) -> ReactionViewReactor {
        return ReactionViewReactor(provider: globalState, initialState: .init(postListData: post), emojiRepository: makeEmojiUseCase(), realEmojiRepository: makeRealEmojiUseCase())
    }
    
    func makeViewController(post: PostListData) -> ReactionViewController {
        return ReactionViewController(reactor: makeReactor(post: post))
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
