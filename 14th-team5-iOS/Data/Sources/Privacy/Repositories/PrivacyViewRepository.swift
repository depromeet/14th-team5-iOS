//
//  PrivacyViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/16/23.
//

import Foundation

import Domain
import RxSwift
import RxCocoa




public final class PrivacyViewRepository {
    
    public init() { }
    
    private let privacyAPIWorker: PrivacyAPIWorker = PrivacyAPIWorker()
    public var disposeBag: DisposeBag = DisposeBag()
    private let accessToken: String = ""
    
}


extension PrivacyViewRepository: PrivacyViewInterface {
    
    public func fetchPrivacyItem() -> Observable<Array<String>> {
        let privacyItems: Array<String> = Privacy.allCases.map { $0.descrption }
        
        
        return Observable.create { observer in
            observer.onNext(privacyItems)
            
            return Disposables.create()
        }
    }
    
    public func fetchAuthorizationItem() -> Observable<Array<String>> {
        let authorizationItems: Array<String> = UserAuthorization.allCases.map { $0.descrption }
        
        return Observable.create { observer in
            observer.onNext(authorizationItems)
            
            return Disposables.create()
        }
    }
    
    public func fetchAccountResign(memberId: String) -> Observable<AccountResignResponse> {
        return privacyAPIWorker.resignUser(accessToken: accessToken, memberId: memberId)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public func fetchBibbiAppVersion(parameter: Encodable) -> Observable<BibbiStoreInfoResponse> {
        return privacyAPIWorker.requestStoreInfo(parameter: parameter)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
}
