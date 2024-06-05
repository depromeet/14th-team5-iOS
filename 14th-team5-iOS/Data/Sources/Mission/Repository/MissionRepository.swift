//
//  MissionRepository.swift
//  Data
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

import RxSwift

public final class MissionRepository: MissionRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let missionAPIWorker: MissionAPIWorker = MissionAPIWorker()
    
    public init() { }
}

extension MissionRepository {
    public func getTodayMission() -> Observable<TodayMissionResponse?> {
        return missionAPIWorker.getTodayMission()
            .asObservable()
    }
    
    public func getMissionContent(missionId: String) -> Observable<MissionContentResponse?> {
        return missionAPIWorker.getMissionContent(missionId: missionId)
            .asObservable()
    }
    
}
