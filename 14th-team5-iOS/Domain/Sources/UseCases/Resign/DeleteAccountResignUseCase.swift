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
    
    private let accountResingRepository: any AccountResignRepositoryProtocol
    
    public init(accountResingRepository: any AccountResignRepositoryProtocol) {
        self.accountResingRepository = accountResingRepository
    }
    
    public func execute() -> Observable<AccountResignEntity?> {
        return accountResingRepository.deleteAccountResignItem()
    }
}
