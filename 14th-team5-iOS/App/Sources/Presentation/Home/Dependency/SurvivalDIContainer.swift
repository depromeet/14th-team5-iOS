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


final class SurvivalDIContainer {
    func makeViewController(type: PostType) -> SurvivalViewController {
        return SurvivalViewController(reactor: makeReactor(type: type))
    }
    
    private func makeReactor(type: PostType) -> SurvivalViewReactor {
        return SurvivalViewReactor(initialState: .init(type: type), postUseCase: makePostUseCase())
    }
}

extension SurvivalDIContainer {
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
