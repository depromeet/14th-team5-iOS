//
//  MainFamilyDIContainer.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import UIKit
import Foundation

import Core
import Data
import Domain

final class MainFamilyViewDIContainer: BaseContainer {
    private func makeInviteFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    private func makeInviteFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeInviteFamilyRepository())
    }
}

extension MainFamilyViewDIContainer {
    func registerDependencies() {
        container.register(type: FamilyUseCaseProtocol.self) { _ in
            self.makeInviteFamilyUseCase()
        }
    }
}
