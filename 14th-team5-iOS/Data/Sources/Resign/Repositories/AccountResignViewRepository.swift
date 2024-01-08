//
//  AccountResignViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 1/2/24.
//

import Foundation

import Core
import Domain
import RxSwift

public final class AccountResignViewRepository {
    
    public init() { }
    
    private let resignAPIWorker: ResignAPIWorker = ResignAPIWorker()
    private let accessToken = App.Repository.token.accessToken.value?.accessToken ?? ""
    public var disposeBag: DisposeBag = DisposeBag()
}

extension AccountResignViewRepository: AccountResignInterface {
    
    public func fetchAccountResign(memberId: String) -> Observable<AccountResignResponse> {
        return resignAPIWorker.resignUser(accessToken: accessToken, memberId: memberId)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public func fetchAccountFcmResign(fcmToken: String) -> Observable<AccountFcmResignResponse> {
        return resignAPIWorker.resignFcmToken(accessToken: accessToken, fcmToken: fcmToken)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
}
