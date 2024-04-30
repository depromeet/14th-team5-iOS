//
//  GetTodayMissionUseCase.swift
//  Domain
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import RxSwift

public final class GetTodayMissionUseCase: GetTodayMissionUseCaseProtocol {
    private let missionRepository: MissionRepositoryProtocol
    
    public init(missionRepository: MissionRepositoryProtocol) {
        self.missionRepository = missionRepository
    }
    
    public func execute() -> Observable<TodayMissionData?> {
        return missionRepository.getTodayMission()
    }
}
