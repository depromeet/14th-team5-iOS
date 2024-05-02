//
//  DescriptionDIContainer.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Data
import Domain

final class DescriptionDIContainer {
    func makeView() -> DescriptionView {
        return DescriptionView(reactor: makeReactor())
    }
    
    func makeReactor() -> DescriptionReactor {
        return DescriptionReactor(missionUseCase: makeUseCase())
    }
}

extension DescriptionDIContainer {
    private func makeRepository() -> MissionRepositoryProtocol {
        return MissionRepository()
    }
    private func makeUseCase() -> GetTodayMissionUseCaseProtocol {
        return GetTodayMissionUseCase(missionRepository: makeRepository())
    }
}
