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
        return HomeViewController(reacter: makeReactor())
    }
    
    public func makePostRepository() -> PostListRepository {
        return PostListAPIs.Worker()
    }
    
    public func makeFamilyRepository() -> SearchFamilyRepository {
        return FamilyAPIs.Worker()
    }
    
    func makePostUseCase() -> PostListUseCaseProtocol {
        return PostListUseCase(postListRepository: makePostRepository())
    }
    
    func makeFamilyUseCase() -> SearchFamilyMemberUseCaseProtocol {
        return SearchFamilyUseCase(searchFamilyRepository: makeFamilyRepository())
    }
    
    public func makeReactor() -> Reactor {
        return HomeViewReactor(familyRepository: makeFamilyUseCase(), postRepository: makePostUseCase())
    }
    
}
