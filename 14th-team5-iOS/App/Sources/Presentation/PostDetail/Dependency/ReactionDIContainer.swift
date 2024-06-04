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
    
    private func makeReactor(post: PostListData) -> ReactionViewReactor {
        return ReactionViewReactor(provider: globalState, initialState: .init(type: type, postListData: post), emojiRepository: makeEmojiUseCase(), realEmojiRepository: makeRealEmojiUseCase())
    }
    
    func makeViewController(post: PostListData) -> ReactionViewController {
        return ReactionViewController(reactor: makeReactor(post: post))
    }
}

extension ReactionDIContainer {
    private func makeRealEmojiRepository() -> RealEmojiRepositoryProtocol {
        return RealEmojiRepository()
    }
    
    private func makeRealEmojiUseCase() -> RealEmojiUseCaseProtocol {
        return RealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
}

extension ReactionDIContainer {
    private func makeReactionRepository() -> ReactionRepositoryProtocol {
        return ReactionRepository()
    }
    
    private func makeEmojiUseCase() -> ReactionUseCaseProtocol {
        return ReactionUseCase(reactionRepository: makeReactionRepository())
    }
}
