//
//  HomeDIContainer.swift
//  App
//
//  Created by 마경미 on 24.12.23.
//

import UIKit

import Data
import Domain
import Core


final class MainViewDIContainer {
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    
    func makeViewController() -> MainViewController {
        return MainViewController(reactor: makeReactor())
    }
}

extension MainViewDIContainer {
    private func makeReactor() -> MainViewReactor {
        return MainViewReactor(
            fetchMainUseCase: makeFetchMainUseCase(), 
            fetchMainNightUseCase: makeFetchMainNightUseCase(),
            pickUseCase: makePickUseCase(),
            checkMissionAlertShowUseCase: makeCheckMissionAlertShowUseCase(),
            provider: globalState
        )
    }
    
    private func makePickReposiotry() -> PickRepositoryProtocol {
        return PickRepository()
    }
    
    private func makePickUseCase() -> PickUseCaseProtocol {
        return PickUseCase(pickRepository: makePickReposiotry())
    }
    
    private func makeMainRepository() -> MainRepository {
        return MainRepository()
    }
    
    private func makeMissionUserDefaultsRepository() -> MissionUserDefaultsRepository {
        return MissionUserDefaultsRepository()
    }
    
    private func makeFetchMainUseCase() -> FetchMainUseCaseProtocol {
        return FetchMainUseCase(mainRepository: makeMainRepository())
    }
    
    private func makeFetchMainNightUseCase() -> FetchMainNightUseCaseProtocol {
        return FetchMainNightUseCase(mainRepository: makeMainRepository())
    }
    
    private func makeCheckMissionAlertShowUseCase() -> CheckMissionAlertShowUseCaseProtocol {
        return CheckMissionAlertShowUseCase(missionUserDefaultsRepository: makeMissionUserDefaultsRepository())
    }
}
