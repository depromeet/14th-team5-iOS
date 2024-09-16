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
        return resignApiWorker.resignUser(memberId: FamilyUserDefaults.getMyMemberId())
            .compactMap { $0?.toDomain() }
            .asObservable()
            
    }
}
