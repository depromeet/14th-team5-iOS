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
    public typealias ViewContrller = HomeViewController
    public typealias Reactor = HomeViewReactor
    
    public func makeViewController() -> ViewContrller {
        return HomeViewController(reactor: makeReactor())
    }
    
    public func makePostRepository() -> PostListRepositoryProtocol {
        return PostListAPIs.Worker()
    }
    
    public func makeFamilyRepository() -> SearchFamilyRepository {
        return FamilyAPIs.Worker()
    }
    
    public func makeMeRepository() -> MeRepositoryProtocol {
        return MeAPIs.Worker()
    }
    
    public func makeInviteFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    func makeMeUseCase() -> MeUseCaseProtocol {
        return MeUseCase(meRepository: makeMeRepository())
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
    
    public func makeReactor() -> Reactor {
        return HomeViewReactor(meRepository: makeMeUseCase(), postRepository: makePostUseCase())
    }
    
}
