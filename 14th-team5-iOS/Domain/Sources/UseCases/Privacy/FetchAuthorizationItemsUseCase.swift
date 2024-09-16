//
//  FetchAuthorizationItemsUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 9/11/24.
//

import Foundation

import RxSwift


public protocol FetchAuthorizationItemsUseCaseProtocol {
    func execute() -> Observable<Array<String>>
}


public final class FetchAuthorizationItemsUseCase: FetchAuthorizationItemsUseCaseProtocol {
    
    private let privacyRepository: any PrivacyRepositoryProtocol
    
    public init(privacyRepository: any PrivacyRepositoryProtocol) {
        self.privacyRepository = privacyRepository
    }
    
    public func execute() -> Observable<Array<String>> {
        return privacyRepository.fetchAuthorizationItems()
    }
}
