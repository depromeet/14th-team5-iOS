//
//  FetchCameraTodayMissionUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation

import RxSwift
import RxCocoa


public protocol FetchCameraTodayMissionUseCaseProtocol {
    func execute() -> Observable<CameraTodayMssionEntity?>
}


public final class FetchCameraTodayMissionUseCase: FetchCameraTodayMissionUseCaseProtocol {
    
    private let cameraRepository: any CameraRepositoryProtocol
    
    public init(cameraRepository: any CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func execute() -> Observable<CameraTodayMssionEntity?> {
        return cameraRepository.fetchDailyMissonItem()
    }
}
