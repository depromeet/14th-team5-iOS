//
//  FetchIsFirstFamilyManagementUseCaseProtocol.swift
//  Domain
//
//  Created by 마경미 on 01.09.24.
//

import Foundation

import RxSwift

public protocol FetchFamilyManagementUseCaseProtocol {
    func execute() -> Observable<Bool>
}

public class FetchFamilyManagementUseCase: FetchFamilyManagementUseCaseProtocol {
    
    private let repository: AppRepositoryProtocol
    
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() -> Observable<Bool> {
        repository.fetchisFirstFamilyManagement().asObservable()
    }
}
