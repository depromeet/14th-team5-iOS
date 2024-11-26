//
//  FetchDailyMissonContentUseCase.swift
//  Domain
//
//  Created by 김도현 on 11/25/24.
//

import Foundation

import RxSwift


public protocol FetchDailyMissonContentUseCaseProtocol {
    func execute() -> Observable<MissonTodayContentEntity?>
}

public final class FetchDailyMissonContentUseCase: FetchDailyMissonContentUseCaseProtocol {
    
    private let missionRepository: any MissionRepositoryProtocol
    
    public init(missionRepository: any MissionRepositoryProtocol) {
        self.missionRepository = missionRepository
    }
    
    public func execute() -> Observable<MissonTodayContentEntity?> {
        return missionRepository.fetchDailyMissonItem()
    }
}
