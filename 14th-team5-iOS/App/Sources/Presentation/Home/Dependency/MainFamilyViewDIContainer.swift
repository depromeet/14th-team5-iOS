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

final class MainFamilyViewDIContainer {
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    
    func makeViewController() -> MainFamilyViewController {
        return MainFamilyViewController(reactor: makeReactor())
    }
    
    private func makeReactor() -> MainFamilyViewReactor {
        return MainFamilyViewReactor(provider: globalState, familyUseCase: makeInviteFamilyUseCase())
    }
}

extension MainFamilyViewDIContainer {
    private func makeInviteFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    private func makeInviteFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeInviteFamilyRepository())
    }
}
