//
//  InputFamilyLinkDIContainer.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import UIKit

import Core
import Data
import Domain

final class InputFamilyLinkDIContainer {
    public func makeViewController() -> InputFamilyLinkViewController {
        return InputFamilyLinkViewController(reactor: makeReactor())
    }
    
    public func makeUsecase() -> JoinFamilyUseCaseProtocol {
        return JoinFamilyUseCase(joinFamilyRepository: makeRepository())
    }
    
    public func makeRepository() -> JoinFamilyRepository {
        return MeAPIs.Worker()
    }
    
    
    public func makeFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeFamilyRepository())
    }
    
    public func makeFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    public func makeReactor() -> InputFamilyLinkReactor {
        return InputFamilyLinkReactor(initialState: .init(), familyUseCase: makeFamilyUseCase())
    }
}

