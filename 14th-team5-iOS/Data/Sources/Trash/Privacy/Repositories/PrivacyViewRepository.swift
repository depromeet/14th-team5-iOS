//
//  PrivacyViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/16/23.
//

import Foundation

import Core
import Domain
import RxSwift
import RxCocoa




public final class PrivacyViewRepository {
    
    public init() { }
    
    private let privacyAPIWorker: PrivacyAPIWorker = PrivacyAPIWorker()
    private let signInHelper: AccountSignInHelper = AccountSignInHelper()
    private let accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
    public var disposeBag: DisposeBag = DisposeBag()
    
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
        
    public func fetchBibbiAppInfo(parameter: Encodable) -> Observable<BibbiAppInfoResponse> {
        return privacyAPIWorker.requestBibbiAppInfo(accessToken: accessToken, parameter: parameter)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public func fetchAccountLogout() -> Observable<Void> {
        guard let accountSnsType = UserDefaults.standard.snsType else { return .empty() }
        return signInHelper.signOut(sns: accountSnsType)
            .asObservable()
    }
    
    
    public func fetchAccountFamilyResign() -> Observable<AccountFamilyResignResponse> {
        return privacyAPIWorker.resignFamily(accessToken: accessToken)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
}
