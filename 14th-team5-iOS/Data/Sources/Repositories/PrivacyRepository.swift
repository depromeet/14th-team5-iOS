//
//  PrivacyRepository.swift
//  Data
//
//  Created by Kim dohyun on 9/11/24.
//

import Domain
import Foundation

import RxSwift

public final class PrivacyRepository: PrivacyRepositoryProtocol {
    
    public init() { }
    
    public func fetchPrivacyItems() -> Observable<Array<String>> {
        let privacyItems: Array<String> = Privacy.allCases.map { $0.descrption }
        
        
        return Observable.create { observer in
            observer.onNext(privacyItems)
            
            return Disposables.create()
        }
    }
    
    public func fetchAuthorizationItems() -> Observable<Array<String>> {
        let authorizationItems: Array<String> = UserAuthorization.allCases.map { $0.descrption }
        
        return Observable.create { observer in
            observer.onNext(authorizationItems)
            
            return Disposables.create()
        }
    }
    
}
