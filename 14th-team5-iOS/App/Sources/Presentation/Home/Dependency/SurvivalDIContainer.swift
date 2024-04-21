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
    func makeViewController() -> SurvivalViewController {
        return SurvivalViewController(reactor: makeReactor())
    }
    
    private func makeReactor() -> SurvivalViewReactor {
        return SurvivalViewReactor(postUseCase: makePostUseCase())
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
