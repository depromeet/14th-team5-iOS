//
//  FamilyDIContainer.swift
//  App
//
//  Created by 마경미 on 21.06.24.
//

import Foundation

import Core
import Data
import Domain

final class FamilyDIContainer: BaseContainer {
    private let repository: FamilyRepositoryProtocol = FamilyRepository()
    
    private func makeInviteFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: repository)
    }
}

extension FamilyDIContainer {
    func registerDependencies() {
        container.register(type: FamilyUseCaseProtocol.self) { _ in
            self.makeInviteFamilyUseCase()
        }
    }
}
