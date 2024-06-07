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


final class MainPostViewDIContainer {
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    func makeViewController(type: PostType) -> MainPostViewController {
        return MainPostViewController(reactor: makeReactor(type: type))
    }
    
    private func makeReactor(type: PostType) -> MainPostViewReactor {
        return MainPostViewReactor(initialState: .init(type: type), provider: globalState, postUseCase: makePostUseCase())
    }
}

extension MainPostViewDIContainer {
    private func makePostRepository() -> PostListRepositoryProtocol {
        return PostRepository()
    }
    
    func makeUploadPostRepository() -> UploadPostRepositoryProtocol {
        return PostUserDefaultsRepository()
    }

    func makePostUseCase() -> PostListUseCaseProtocol {
        return PostListUseCase(postListRepository: makePostRepository(), uploadePostRepository: makeUploadPostRepository())
    }
}
