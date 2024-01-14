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

final class JoinFamilyDIContainer {
    public func makeViewController() -> JoinFamilyViewController {
        return JoinFamilyViewController(reactor: makeReactor())
    }
    
    public func makeUsecase() -> FamilyViewUseCaseProtocol {
        return InviteFamilyViewUseCase(familyRepository: makeRepository())
    }
    
    public func makeRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    public func makeReactor() -> JoinFamilyReactor {
        return JoinFamilyReactor(initialState: .init(), familyUseCase: makeUsecase())
    }
}
