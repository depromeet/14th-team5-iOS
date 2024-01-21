//
//  PrivacyViewUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation

import RxSwift


public protocol PrivacyViewUseCaseProtocol {
    func executePrivacyItems() -> Observable<Array<String>>
    func executeAuthorizationItem() -> Observable<Array<String>>
    func executeBibbiAppInfo(parameter: Encodable) -> Observable<BibbiAppInfoResponse>
    func executeLogout() -> Observable<Void>
    func executeAccountFamilyResign() -> Observable<AccountFamilyResignResponse>
}


public final class PrivacyViewUseCase: PrivacyViewUseCaseProtocol {
    private let privacyViewRepository: PrivacyViewInterface
    
    public init(privacyViewRepository: PrivacyViewInterface) {
        self.privacyViewRepository = privacyViewRepository
    }
    
    public func executePrivacyItems() -> Observable<Array<String>> {
        return privacyViewRepository.fetchPrivacyItem()
    }
    
    public func executeAuthorizationItem() -> Observable<Array<String>> {
        return privacyViewRepository.fetchAuthorizationItem()
    }
    
    public func executeBibbiAppInfo(parameter: Encodable) -> Observable<BibbiAppInfoResponse> {
        return privacyViewRepository.fetchBibbiAppInfo(parameter: parameter)
    }
    
    public func executeLogout() -> Observable<Void> {
        return privacyViewRepository.fetchAccountLogout()
        
    }
    
    public func executeAccountFamilyResign() -> Observable<AccountFamilyResignResponse> {
        return privacyViewRepository.fetchAccountFamilyResign()
    }
}
