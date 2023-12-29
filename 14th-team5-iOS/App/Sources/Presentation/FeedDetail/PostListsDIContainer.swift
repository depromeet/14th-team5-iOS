//
//  PostListsDIContainer.swift
//  App
//
//  Created by 마경미 on 30.12.23.
//

import Foundation
import Data
import Domain

final class PostListsDIContainer {
    typealias ViewContrller = PostViewController
    typealias Reactor = PostReactor
    
    func makeViewController(postLists: PostListData, selectedIndex: IndexPath) -> ViewContrller {
        return PostViewController(reactor: makeReactor(postLists: postLists, selectedIndex: selectedIndex.row))
    }
    
    func makePostRepository() -> PostListRepository {
        return PostListAPIs.Worker()
    }
    
    func makePostUseCase() -> PostListUseCaseProtocol {
        return PostListUseCase(postListRepository: makePostRepository())
    }
    
    func makeReactor(postLists: PostListData, selectedIndex: Int) -> Reactor {
        return PostReactor(postRepository: makePostUseCase(), initialState: PostReactor.State(postLists: postLists, selectedPostIndex: selectedIndex))
    }
    
}
