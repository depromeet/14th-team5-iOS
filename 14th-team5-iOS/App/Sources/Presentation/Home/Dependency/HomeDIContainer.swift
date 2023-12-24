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


public final class HomeDIContainer: BaseDIContainer {
    public typealias Repository = SearchFamilyRepository
    
    public typealias ViewContrller = HomeViewController
    public typealias Reactor = HomeViewReactor
    
    public func makeViewController() -> ViewContrller {
        return HomeViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> SearchFamilyRepository {
        return FamiliyAPIs.Worker()
    }
    
    func makeUseCase() -> SearchFamilyMemberUseCaseProtocol {
        return SearchFamilyUseCase(searchFamilyRepository: makeRepository())
    }
    
    public func makeReactor() -> Reactor {
        return HomeViewReactor(repository: makeUseCase())
    }
    
}
