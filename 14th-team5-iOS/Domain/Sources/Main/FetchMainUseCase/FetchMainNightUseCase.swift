//
//  FetchMainNightUseCase.swift
//  Domain
//
//  Created by 마경미 on 07.05.24.
//

import Foundation

import RxSwift

public final class FetchMainNightUseCase: FetchMainNightUseCaseProtocol {
    private let mainRepository: MainRepositoryProtocol
    
    public init(mainRepository: MainRepositoryProtocol) {
        self.mainRepository = mainRepository
    }
    
    public func execute() -> Observable<MainNightData?> {
        return mainRepository.fetchMainNight()
    }
}

