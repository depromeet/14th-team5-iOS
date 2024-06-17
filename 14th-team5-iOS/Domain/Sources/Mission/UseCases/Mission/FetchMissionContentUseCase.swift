//
//  FetchMissionContentUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/16/24.
//

import Foundation

import RxSwift
import RxCocoa


public protocol FetchMissionContentUseCaseProtocol {
    func execute(missionId: String) -> Single<MissionContentEntity?>
}

public final class FetchMissionContentUseCase: FetchMissionContentUseCaseProtocol {
    private let missionRepository: any MissionRepositoryProtocol
    
    public init(missionRepository: any MissionRepositoryProtocol) {
        self.missionRepository = missionRepository
    }
    
    public func execute(missionId: String) -> Single<MissionContentEntity?> {
        return missionRepository.getMissionContent(missionId: missionId)
    }
    
}
