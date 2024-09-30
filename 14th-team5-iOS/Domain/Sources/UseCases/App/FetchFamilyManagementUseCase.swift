//
//  FetchIsFirstFamilyManagementUseCaseProtocol.swift
//  Domain
//
//  Created by 마경미 on 01.09.24.
//

import Foundation

import RxSwift

public protocol FetchIsFirstFamilyManagementUseCaseProtocol {
    func execute() -> Observable<Bool>
}

public class FetchFamilyManagementUseCase: FetchIsFirstFamilyManagementUseCaseProtocol {
    
    private let repository: AppRepositoryProtocol
    
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() -> Observable<Bool> {
        repository.fetchIsFirstFamilyManagement()
            .map { isFirst in
                guard let isFirst else {
                    return true
                }
                return isFirst
            }
            .asObservable()
    }
}
