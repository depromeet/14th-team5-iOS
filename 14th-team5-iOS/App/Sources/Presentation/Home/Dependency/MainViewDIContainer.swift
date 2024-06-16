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
    
    private func makeMainRepository() -> MainViewRepository {
        return MainViewRepository()
    }
    
    private func makeMissionRepository() -> MissionRepositoryProtocol {
        return MissionRepository()
    }
    
    private func makeFetchMainUseCase() -> FetchMainUseCaseProtocol {
        return FetchMainUseCase(mainRepository: makeMainRepository())
    }
    
    private func makeFetchMainNightUseCase() -> FetchNightMainViewUseCaseProtocol {
        return FetchNightMainViewUseCase(mainRepository: makeMainRepository())
    }
    
    private func makeCheckMissionAlertShowUseCase() -> CheckMissionAlertShowUseCaseProtocol {
        return CheckMissionAlertShowUseCase(missionRepository: makeMissionRepository())
    }
}
