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
    
    public func fetchAccountResign() -> Observable<AccountResignResponse> {
        return resignAPIWorker.resignUser(accessToken: accessToken, memberId: FamilyUserDefaults.getMyMemberId())
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
}
