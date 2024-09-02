//
//  AccountResignUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 1/2/24.
//

import Foundation

import RxSwift

public protocol AccountResignUseCaseProtocol {
    func executeAccountResign() -> Observable<AccountResignResponse>
}


public final class AccountResignUseCase: AccountResignUseCaseProtocol {
    private let accountResignViewRepository: AccountResignInterface
    
    public init(accountResignViewRepository: AccountResignInterface) {
        self.accountResignViewRepository = accountResignViewRepository
    }
    
    public func executeAccountResign() -> Observable<AccountResignResponse> {
        return accountResignViewRepository.fetchAccountResign()
    }
}
