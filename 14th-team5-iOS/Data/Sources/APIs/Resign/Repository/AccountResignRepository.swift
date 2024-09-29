//
//  AccountResignRepository.swift
//  Data
//
//  Created by Kim dohyun on 9/12/24.
//

import Domain
import Foundation

import RxSwift

public final class AccountResignRepository: AccountResignRepositoryProtocol {
    
    public let disposeBag: DisposeBag = DisposeBag()
    private let resignApiWorker: ResignAPIWorker = ResignAPIWorker()
    public init() { }
}

extension AccountResignRepository {
    
    public func deleteAccountResignItem() -> Observable<AccountResignEntity?> {
        let myUserDefaults = MyUserDefaults()
        let currentMemberId = myUserDefaults.loadMemberId() ?? "NONE"
        
        return resignApiWorker.resignUser(memberId: currentMemberId)
            .compactMap { $0?.toDomain() }
            .asObservable()
            
    }
}
