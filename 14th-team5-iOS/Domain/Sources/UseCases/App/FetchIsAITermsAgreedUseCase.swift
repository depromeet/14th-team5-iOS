//
//  FetchIsAITermsAgreedUseCase.swift
//  Domain
//
//  Created by 마경미 on 27.09.25.
//

import Foundation

import RxSwift

public protocol FetchIsAITermsAgreedUseCaseProtocol {
    func execute() -> Observable<Bool>
}

public class FetchIsAITermsAgreedUseCase: FetchIsAITermsAgreedUseCaseProtocol {
    
    private let repository: AppRepositoryProtocol
    
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() -> Observable<Bool> {
        repository.loadIsAITermsAgreed()
            .map { isAgreed in
                guard let isAgreed else {
                    return false
                }
                return isAgreed
            }
            .asObservable()
    }
}
