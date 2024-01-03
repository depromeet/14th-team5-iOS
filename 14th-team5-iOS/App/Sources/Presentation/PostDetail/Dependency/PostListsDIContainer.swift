//
//  PostListsDIContainer.swift
//  App
//
//  Created by 마경미 on 30.12.23.
//

import Foundation
import Data
import Domain

import RxDataSources

final class PostListsDIContainer {
    typealias ViewContrller = PostViewController
    typealias Reactor = PostReactor
    
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
        return PostReactor(postRepository: makePostUseCase(), emojiRepository: makeEmojiUseCase(), initialState: PostReactor.State(originPostLists: [postLists]))
    }
    
}
