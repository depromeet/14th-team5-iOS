//
//  AccountResignUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 1/2/24.
//

import Foundation

import RxSwift

public protocol AccountResignUseCaseProtocol {
    func executeAccountResign(memberId: String) -> Observable<AccountResignResponse>
    func executeAccountFcmResign(fcmToken: String) -> Observable<AccountFcmResignResponse>
    
}


public final class AccountResignUseCase: AccountResignUseCaseProtocol {
    private let accountResignViewRepository: AccountResignInterface
    
    public init(accountResignViewRepository: AccountResignInterface) {
        self.accountResignViewRepository = accountResignViewRepository
    }
    
    public func executeAccountResign(memberId: String) -> Observable<AccountResignResponse> {
        return accountResignViewRepository.fetchAccountResign(memberId: memberId)
    }
    
    public func executeAccountFcmResign(fcmToken: String) -> Observable<AccountFcmResignResponse> {
        return accountResignViewRepository.fetchAccountFcmResign(fcmToken: fcmToken)
    }
}
