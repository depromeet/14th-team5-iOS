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
    private let postListRepository: PostRepositoryProtocol = PostRepository()

    private func makePostUseCase() -> FetchPostListUseCaseProtocol {
        return FetchPostListUseCase(
            postListRepository: postListRepository,
            familyRepository: familyRepository)
    }

    private func makeStudioPostUseCase() -> FetchStudioPostListUseCaseProtocol {
        return FetchStudioPostListUseCase(
            postListRepository: postListRepository,
            familyRepository: familyRepository)
    }
    
    private func makeFetchMembersPostListUseCase() -> FetchMembersPostListUseCaseProtocol {
        return FetchMembersPostListUseCase(postListRepository: postListRepository)
    }
    
    private func makeCreatePostUseCase() -> CreatePostUseCaseProtocol {
        return CreatePostUseCase(postListRepository: postListRepository)
    }
    
    private func makeCreatePresignedURLUseCase() -> CreatePresignedURLUseCaseProtocol {
        return CreatePresignedURLUseCase(postListReposity: postListRepository)
    }
    
    private func makeFetchPostUseCase() -> FetchPostUseCaseProtocol {
        return FetchPostUseCase(
            postRepository: postListRepository,
            familyRepository: familyRepository
        )
    }

    private func makeCreateImageUploadUseCase() -> CreateImageUploadUseCaseProtocol {
        return CreateImageUploadUseCase(postListRepository: postListRepository)
    }
}

extension PostDIContainer {
    func registerDependencies() {
        container.register(type: FetchPostListUseCaseProtocol.self) { _ in
            self.makePostUseCase()
        }
        
        container.register(type: FetchStudioPostListUseCaseProtocol.self) { _ in
            self.makeStudioPostUseCase()
        }
        
        container.register(type: FetchMembersPostListUseCaseProtocol.self) { _ in
            self.makeFetchMembersPostListUseCase()
        }
        
        container.register(type: CreatePostUseCaseProtocol.self) { _ in
            self.makeCreatePostUseCase()
        }
        
        container.register(type: CreatePresignedURLUseCaseProtocol.self) { _ in
            self.makeCreatePresignedURLUseCase()
        }
        
        container.register(type: FetchPostUseCaseProtocol.self) { _ in
            self.makeFetchPostUseCase()
        }
      
        container.register(type: CreateImageUploadUseCaseProtocol.self) { _ in
            self.makeCreateImageUploadUseCase()
        }
    }
}

