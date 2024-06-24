//
//  PostDIContainer.swift
//  App
//
//  Created by 마경미 on 21.06.24.
//

import Core
import Data
import Domain


final class PostDIContainer: BaseContainer {
    private let repository: PostListRepositoryProtocol = PostRepository()

    private func makePostUseCase() -> FetchPostListUseCaseProtocol {
        return FetchPostListUseCase(postListRepository: repository)
    }
    
    private func makeFetchMembersPostListUseCase() -> FetchMembersPostListUseCaseProtocol {
        return FetchMembersPostListUseCase(postListRepository: repository)
    }
}

extension PostDIContainer {
    func registerDependencies() {
        container.register(type: FetchPostListUseCaseProtocol.self) { _ in
            self.makePostUseCase()
        }
        
        container.register(type: FetchMembersPostListUseCaseProtocol.self) { _ in
            self.makeFetchMembersPostListUseCase()
        }
    }
}

