//
//  DeleteAccountResignUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 9/12/24.
//

import Foundation

import RxSwift

public protocol DeleteAccountResignUseCaseProtocol {
    func execute() -> Observable<AccountResignEntity?>
}

public final class DeleteAccountResignUseCase: DeleteAccountResignUseCaseProtocol {
    
    private let accountResignRepository: any AccountResignRepositoryProtocol
    
    public init(accountResignRepository: any AccountResignRepositoryProtocol) {
        self.accountResignRepository = accountResignRepository
    }
    
    public func execute() -> Observable<AccountResignEntity?> {
        return accountResignRepository.deleteAccountResignItem()
    }
}
