//
//  MissionContentUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 5/9/24.
//

import Foundation

import RxSwift

public protocol MissionContentUseCaseProtocol {
    func execute(missionId: String) -> Observable<MissionContentResponse>
}


public class MissionContentUseCase: MissionContentUseCaseProtocol {
    
    private let missionContentRepository: MissionRepositoryProtocol
    
    public init(missionContentRepository: MissionRepositoryProtocol) {
        self.missionContentRepository = missionContentRepository
    }
    
    public func execute(missionId: String) -> Observable<MissionContentResponse> {
        return missionContentRepository.getMissionContent(missionId: missionId)
            .compactMap { $0 }
            .asObservable()
    }
    
}
