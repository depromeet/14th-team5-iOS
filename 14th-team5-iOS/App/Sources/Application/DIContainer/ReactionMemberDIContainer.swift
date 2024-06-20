//
//  ReactionDIContainer.swift
//  App
//
//  Created by 마경미 on 07.01.24.
//

import UIKit

import Core
import Data
import Domain

import RxDataSources

final class ReactionMemberDIContainer: BaseContainer {
    private func makeFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    private func makeFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeFamilyRepository())
    }
}

extension ReactionMemberDIContainer {
    func registerDependencies() {
        container.register(type: FamilyUseCaseProtocol.self) { _ in
            self.makeFamilyUseCase()
        }
    }
}
