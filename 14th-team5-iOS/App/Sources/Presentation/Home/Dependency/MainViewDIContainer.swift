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


final class MainViewDIContainer: BaseContainer {
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

extension MainViewDIContainer {
    func registerDependencies() {
        container.register(type: PickUseCaseProtocol.self) { _ in
            self.makePickUseCase()
        }
        
        container.register(type: FetchMainUseCaseProtocol.self) { _ in
            self.makeFetchMainUseCase()
        }
        
        container.register(type: FetchNightMainViewUseCaseProtocol.self) { _ in
            self.makeFetchMainNightUseCase()
        }
        
        container.register(type: CheckMissionAlertShowUseCaseProtocol.self) {_ in
            self.makeCheckMissionAlertShowUseCase()
        }
    }
}
