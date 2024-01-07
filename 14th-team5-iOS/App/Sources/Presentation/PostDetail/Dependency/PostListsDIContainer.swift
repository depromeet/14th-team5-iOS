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
    
    func makeViewController(postLists: SectionModel<String, PostListData>, selectedIndex: IndexPath) -> ViewContrller {
        return PostViewController(reactor: makeReactor(postLists: postLists, selectedIndex: selectedIndex.row))
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
    
    func makeEmojiUseCase() -> EmojiUseCaseProtocol {
        return EmojiUseCase(emojiRepository: makeEmojiRepository())
    }
    
    func makeReactor(postLists: SectionModel<String, PostListData>, selectedIndex: Int) -> Reactor {
        return PostReactor(provider: globalState, postRepository: makePostUseCase(), emojiRepository: makeEmojiUseCase(), initialState: PostReactor.State(originPostLists: [postLists]))
    }
}
