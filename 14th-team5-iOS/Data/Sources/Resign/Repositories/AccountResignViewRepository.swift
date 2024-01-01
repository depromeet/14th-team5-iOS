//
//  AccountResignViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 1/2/24.
//

import Foundation

import Domain
import RxSwift

public final class AccountResignViewRepository {
    
    public init() { }
    
    private let resignAPIWorker: ResignAPIWorker = ResignAPIWorker()
    public var disposeBag: DisposeBag = DisposeBag()
    private let accessToken = ""
}

extension AccountResignViewRepository: AccountResignInterface {
    
    public func fetchAccountResign(memberId: String) -> Observable<AccountResignResponse> {
        return resignAPIWorker.resignUser(accessToken: accessToken, memberId: memberId)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
}
