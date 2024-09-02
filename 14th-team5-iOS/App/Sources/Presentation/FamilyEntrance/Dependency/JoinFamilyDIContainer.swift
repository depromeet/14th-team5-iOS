//
//  JoinFamilyDIContainer.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import UIKit

import Core
import Data
import Domain

@available(*, deprecated, renamed: "JoinFamilyViewControllerWrapper")
final class JoinFamilyDIContainer {
    public func makeViewController() -> JoinFamilyViewController {
        return JoinFamilyViewController(reactor: makeReactor())
    }
    
    public func makeUsecase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeRepository())
    }
    
    public func makeRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    public func makeReactor() -> JoinFamilyReactor {
        return JoinFamilyReactor()
    }
}
