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
    private let familyRepository: FamilyRepositoryProtocol = FamilyRepository()
    private let postListRepository: PostListRepositoryProtocol = PostRepository()

    private func makePostUseCase() -> FetchPostListUseCaseProtocol {
        return FetchPostListUseCase(postListRepository: postListRepository, familyRepository: familyRepository)
    }
    
    private func makeFetchMembersPostListUseCase() -> FetchMembersPostListUseCaseProtocol {
        return FetchMembersPostListUseCase(postListRepository: postListRepository)
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

