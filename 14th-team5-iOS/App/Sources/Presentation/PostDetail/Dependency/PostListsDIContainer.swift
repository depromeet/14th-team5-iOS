//
//  PostListsDIContainer.swift
//  App
//
//  Created by 마경미 on 30.12.23.
//

import UIKit

import Core
import Data
import Domain

import RxDataSources

final class PostListsDIContainer {
    typealias ViewContrller = PostViewController
    typealias Reactor = PostReactor
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    func makeViewController(
        postLists: PostSection.Model,
        selectedIndex: IndexPath,
        postId: String? = nil,
        openComment: Bool = false
    ) -> ViewContrller {
        return PostViewController(reactor: makeReactor(
            postLists: postLists,
            selectedIndex: selectedIndex.row,
            postId: postId,
            openComment: openComment)
        )
    }
    
    func makePostRepository() -> PostListRepositoryProtocol {
        return PostListAPIs.Worker()
    }
    
    func makePostUseCase() -> PostListUseCaseProtocol {
        return PostListUseCase(postListRepository: makePostRepository())
    }
    
    func makeEmojiRepository() -> EmojiRepository {
        return EmojiAPIs.Worker()
    }
    
    func makeRealEmojiRepository() -> RealEmojiRepository {
        return RealEmojiAPIS.Worker()
    }
    
    func makeEmojiUseCase() -> EmojiUseCaseProtocol {
        return EmojiUseCase(emojiRepository: makeEmojiRepository())
    }
    
    func makeRealEmojiUseCase() -> RealEmojiUseCaseProtocol {
        return RealEmojiUseCase(realEmojiRepository: makeRealEmojiRepository())
    }
    
    func makeReactor(
        postLists: PostSection.Model,
        selectedIndex: Int,
        postId: String?,
        openComment: Bool
    ) -> Reactor {
        return PostReactor(
            provider: globalState,
            realEmojiRepository: makeRealEmojiUseCase(),
            emojiRepository: makeEmojiUseCase(),
            postId: postId,
            openComment: openComment,
            initialState: PostReactor.State(selectedIndex: selectedIndex, originPostLists: postLists)
        )
    }
}
