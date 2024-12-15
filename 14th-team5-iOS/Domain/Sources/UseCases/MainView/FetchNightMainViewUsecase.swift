//
//  FetchMainNightUseCaseProtocol.swift
//  Domain
//
//  Created by 마경미 on 07.05.24.
//

import Foundation

import RxSwift

public protocol FetchNightMainViewUseCaseProtocol {
    func execute() -> Observable<NightMainViewEntity>
}

public final class FetchNightMainViewUseCase: FetchNightMainViewUseCaseProtocol {
    private let mainRepository: MainViewRepositoryProtocol
    
    public init(mainRepository: MainViewRepositoryProtocol) {
        self.mainRepository = mainRepository
    }
    
    public func execute() -> Observable<NightMainViewEntity> {
        return mainRepository.fetchMainNight()
    }
}
