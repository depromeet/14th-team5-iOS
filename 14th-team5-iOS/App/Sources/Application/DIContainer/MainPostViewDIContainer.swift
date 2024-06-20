//
//  SurvivalDIContainer.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import UIKit

import Core
import Data
import Domain


final class MainPostViewDIContainer: BaseContainer {
    private func makePostRepository() -> PostListRepositoryProtocol {
        return PostRepository()
    }

    private func makePostUseCase() -> FetchPostListUseCaseProtocol {
        return FetchPostListUseCase(postListRepository: makePostRepository())
    }
}

extension MainPostViewDIContainer {
    func registerDependencies() {
        container.register(type: FetchPostListUseCaseProtocol.self) { _ in
            self.makePostUseCase()
        }
    }
}
