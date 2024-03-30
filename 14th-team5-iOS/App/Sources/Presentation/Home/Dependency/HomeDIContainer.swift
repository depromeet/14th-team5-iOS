//
//  HomeDIContainer.swift
//  App
//
//  Created by 마경미 on 24.12.23.
//

import UIKit

import Data
import Domain
import Core


final class HomeDIContainer {
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    
    func makeViewController() -> HomeViewController {
        return HomeViewController(reactor: makeReactor())
    }
    
    private func makeReactor() -> HomeViewReactor {
        return HomeViewReactor(provider: globalState, familyUseCase: makeFamilyUseCase(), postUseCase: makePostUseCase())
    }
}

extension HomeDIContainer {
    private func makePostRepository() -> PostListRepositoryProtocol {
        return PostListAPIs.Worker()
    }
    
    private func makeFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }

    private func makeInviteFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    func makeUploadPostRepository() -> UploadPostRepositoryProtocol {
        return PostUserDefaultsRepository()
    }
    
    func makePostUseCase() -> PostListUseCaseProtocol {
        return PostListUseCase(postListRepository: makePostRepository(), uploadePostRepository: makeUploadPostRepository())
    }
    
    private func makeFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeFamilyRepository())
    }
    
    private func makeInviteFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeInviteFamilyRepository())
    }
}
