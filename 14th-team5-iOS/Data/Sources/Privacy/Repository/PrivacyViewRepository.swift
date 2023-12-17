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

public protocol PrivacyViewImpl: AnyObject {
    var disposeBag: DisposeBag { get }
    
    func fetchPrivacyItem() -> Observable<Array<String>>
    func fetchAuthorizationItem() -> Observable<Array<String>>
}



public final class PrivacyViewRepository: PrivacyViewImpl {
    
    public init() { }
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    public func fetchPrivacyItem() -> Observable<Array<String>> {
        let privacyItems: Array<String> = Privacy.allCases.map { $0.rawValue }
        
        
        return Observable.create { observer in
            observer.onNext(privacyItems)
            
            return Disposables.create()
        }
    }
    
    public func fetchAuthorizationItem() -> Observable<Array<String>> {
        let authorizationItems: Array<String> = UserAuthorization.allCases.map { $0.rawValue }
        
        return Observable.create { observer in
            observer.onNext(authorizationItems)
            
            return Disposables.create()
        }
    }
    
}
