//
//  FetchAppVersionUseCase.swift
//  Domain
//
//  Created by 김건우 on 7/10/24.
//

import Foundation

import RxSwift

public protocol FetchAppVersionUseCaseProtocol {
    func execute() -> Observable<AppVersionEntity>
}

public class FetchAppVersionUseCase: FetchAppVersionUseCaseProtocol {
    
    // MARK: - Repositories
    let appRepository: AppRepositoryProtocol
    
    // MARK: - Intializer
    public init(appRepository: AppRepositoryProtocol) {
        self.appRepository = appRepository
    }
    
    // MARK: - Execute
    
    public func execute() -> Observable<AppVersionEntity> {
        appRepository.fetchAppVersion()
    }
    
}
