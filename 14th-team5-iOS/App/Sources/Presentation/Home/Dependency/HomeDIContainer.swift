//
//  HomeDIContainer.swift
//  App
//
//  Created by 마경미 on 24.12.23.
//

import Foundation
import Data
import Domain
import Core


public final class HomeDIContainer {
    func makeViewController() -> HomeViewController {
        return HomeViewController(reactor: makeReactor())
    }
    
    public func makePostRepository() -> PostListRepositoryProtocol {
        return PostListAPIs.Worker()
    }
    
    public func makeFamilyRepository() -> SearchFamilyRepository {
        return FamilyAPIs.Worker()
    }

    public func makeInviteFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    func makePostUseCase() -> PostListUseCaseProtocol {
        return PostListUseCase(postListRepository: makePostRepository())
    }
    
    func makeFamilyUseCase() -> SearchFamilyMemberUseCaseProtocol {
        return SearchFamilyUseCase(searchFamilyRepository: makeFamilyRepository())
    }
    
    func makeInviteFamilyUseCase() -> FamilyViewUseCaseProtocol {
        return FamilyViewUseCase(familyRepository: makeInviteFamilyRepository())
    }
    
    func makeReactor() -> HomeViewReactor {
        return HomeViewReactor(postRepository: makePostUseCase())
    }
    
}
