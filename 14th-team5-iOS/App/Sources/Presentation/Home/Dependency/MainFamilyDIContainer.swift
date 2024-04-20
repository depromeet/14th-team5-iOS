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

final class MainFamilyDIContainer {
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    
    func makeViewController() -> MainFamilyViewController {
        return MainFamilyViewController(reactor: makeReactor())
    }
    
    private func makeReactor() -> MainFamilyReactor {
        return MainFamilyReactor(provider: globalState, familyUseCase: makeInviteFamilyUseCase(), fetchMainUseCase: makeFetchMainUseCase())
    }
}

extension MainFamilyDIContainer {
    private func makeInviteFamilyRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    private func makeInviteFamilyUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeInviteFamilyRepository())
    }
    
    private func makeMainRepository() -> MainRepository {
        return MainRepository()
    }
    
    private func makeFetchMainUseCase() -> FetchMainUseCaseProtocol {
        return FetchMainUseCase(mainRepository: makeMainRepository())
    }
}
