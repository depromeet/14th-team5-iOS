//
//  SurvivalDIContainer.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Data
import Domain


final class MainPostViewDIContainer {
    func makeViewController(type: PostType) -> MainPostViewController {
        return MainPostViewController(reactor: makeReactor(type: type))
    }
    
    private func makeReactor(type: PostType) -> MainPostViewReactor {
        return MainPostViewReactor(initialState: .init(type: type), postUseCase: makePostUseCase())
    }
}

extension MainPostViewDIContainer {
    private func makePostRepository() -> PostListRepositoryProtocol {
        return PostListAPIs.Worker()
    }
    
    func makeUploadPostRepository() -> UploadPostRepositoryProtocol {
        return PostUserDefaultsRepository()
    }

    func makePostUseCase() -> PostListUseCaseProtocol {
        return PostListUseCase(postListRepository: makePostRepository(), uploadePostRepository: makeUploadPostRepository())
    }
}
