//
//  FetchPrivacyItemsUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 9/11/24.
//

import Foundation

import RxSwift

public protocol FetchPrivacyItemsUseCaseProtocol {
    func execute() -> Observable<Array<String>>
}

public final class FetchPrivacyItemsUseCase: FetchPrivacyItemsUseCaseProtocol {
    
    private let privacyRepository: any PrivacyRepositoryProtocol
    
    public init(privacyRepository: any PrivacyRepositoryProtocol) {
        self.privacyRepository = privacyRepository
    }
    
    public func execute() -> Observable<Array<String>> {
        return privacyRepository.fetchPrivacyItems()
    }
}
