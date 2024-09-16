//
//  AccountResignRepository.swift
//  Domain
//
//  Created by Kim dohyun on 9/12/24.
//

import Foundation

import RxSwift

public protocol AccountResignRepositoryProtocol {
    func deleteAccountResignItem() -> Observable<AccountResignEntity?>
}
