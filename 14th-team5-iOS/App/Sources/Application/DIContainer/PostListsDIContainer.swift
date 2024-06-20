//
//  PostListsDIContainer.swift
//  App
//
//  Created by 마경미 on 30.12.23.
//

import UIKit

import Core
import Data
import Domain

import RxDataSources

final class PostListsDIContainer: BaseContainer {
    
    private func makeMissionRepository() -> MissionRepositoryProtocol {
        return MissionRepository()
    }
    
    func makeMissionUseCase() -> FetchMissionContentUseCaseProtocol {
        return FetchMissionContentUseCase(missionRepository: makeMissionRepository())
    }
    
    func registerDependencies() {
        container.register(type: FetchMissionContentUseCaseProtocol.self) { _ in
            self.makeMissionUseCase()
        }
    }
}
