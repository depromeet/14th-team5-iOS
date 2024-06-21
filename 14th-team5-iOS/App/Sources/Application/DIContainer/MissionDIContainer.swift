//
//  MissionDIContainer.swift
//  App
//
//  Created by 마경미 on 21.06.24.
//

import Core
import Data
import Domain

final class MissionDIContainer: BaseContainer {
    private let repository: MissionRepositoryProtocol = MissionRepository()
    
    func makeMissionUseCase() -> FetchMissionContentUseCaseProtocol {
        return FetchMissionContentUseCase(missionRepository: repository)
    }
    
    private func makeCheckMissionAlertShowUseCase() -> CheckMissionAlertShowUseCaseProtocol {
        return CheckMissionAlertShowUseCase(missionRepository: repository)
    }
    
    func registerDependencies() {
        container.register(type: FetchMissionContentUseCaseProtocol.self) { _ in
            self.makeMissionUseCase()
        }
        
        container.register(type: CheckMissionAlertShowUseCaseProtocol.self) { _ in
            self.makeCheckMissionAlertShowUseCase()
        }
    }
}

