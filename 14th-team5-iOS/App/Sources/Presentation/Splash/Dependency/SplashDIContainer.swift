//
//  SplashDIContainer.swift
//  App
//
//  Created by geonhui Yu on 1/5/24.
//

import Foundation
import Data
import Domain
import Core

@available(*, deprecated, renamed: "SplashViewControllerWrapper")
public final class SplashDIContainer {
    public typealias ViewContrller = SplashViewController
    public typealias Reactor = SplashReactor
    
    public func makeViewController() -> ViewContrller {
        return SplashViewController(reactor: makeReactor())
    }
    
    public func makeMeRepository() -> MeRepositoryProtocol {
        return MeAPIs.Worker()
    }
    
    func makeMeUseCase() -> MeUseCaseProtocol {
        return MeUseCase(meRepository: makeMeRepository())
    }
    
    public func makeFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    public func makeFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeFamilyRepository())
    }
    
    public func makeReactor() -> Reactor {
        return SplashReactor()
    }
}
