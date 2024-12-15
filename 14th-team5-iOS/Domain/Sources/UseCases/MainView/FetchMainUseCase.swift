//
//  MainUseCase.swift
//  Domain
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

import RxSwift

public protocol FetchMainUseCaseProtocol {
    func execute() -> Observable<MainViewEntity>
}

public final class FetchMainUseCase: FetchMainUseCaseProtocol {
    private let mainRepository: MainViewRepositoryProtocol
    
    public init(mainRepository: MainViewRepositoryProtocol) {
        self.mainRepository = mainRepository
    }
    
    public func execute() -> Observable<MainViewEntity> {
        return mainRepository.fetchMain()
    }
}
