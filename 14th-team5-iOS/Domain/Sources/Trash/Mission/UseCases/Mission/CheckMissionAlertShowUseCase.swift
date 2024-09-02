//
//  CheckMissionUseCase.swift
//  Domain
//
//  Created by 마경미 on 03.06.24.
//

import Foundation

import RxSwift

public protocol CheckMissionAlertShowUseCaseProtocol {
    func execute() -> Observable<Bool>
}


public class CheckMissionAlertShowUseCase: CheckMissionAlertShowUseCaseProtocol {
    private let missionRepository: any MissionRepositoryProtocol
    
    public init(missionRepository: any MissionRepositoryProtocol) {
        self.missionRepository = missionRepository
    }
    
    public func execute() -> Observable<Bool> {
        return missionRepository.isAlreadyShowMissionAlert()
    }
}
