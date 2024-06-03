//
//  CheckMissionUseCase.swift
//  Domain
//
//  Created by 마경미 on 03.06.24.
//

import Foundation

import RxSwift

public class CheckMissionAlertShowUseCase: CheckMissionAlertShowUseCaseProtocol {
    private let missionUserDefaultsRepository: MissionUserdefaultsRepositoryProtocol
    
    public init(missionUserDefaultsRepository: MissionUserdefaultsRepositoryProtocol) {
        self.missionUserDefaultsRepository = missionUserDefaultsRepository
    }
    
    public func execute() -> Observable<Bool> {
        return missionUserDefaultsRepository.isAlreadyShowMissionAlert().asObservable()
    }
}
