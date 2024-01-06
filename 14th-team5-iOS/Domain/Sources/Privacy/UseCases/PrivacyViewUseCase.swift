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
    func executeBibbiAppCheck(parameter: Encodable) -> Observable<Bool>
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
    
    public func executeBibbiAppCheck(parameter: Encodable) -> Observable<Bool> {
        return privacyViewRepository.fetchBibbiAppVersion(parameter: parameter)
            .asObservable()
            .flatMap { entity -> Observable<Bool> in
                guard let appInfo = entity.results?.first,
                      let appVersion = appInfo.version
                else { return .just(false) } // app Store에 올려져 있지 않아서 빈 배열로 넘겨지고 있음 그래서 false 처리함
                //Store 버전이 높을 경우 true
                if NSString(string: appVersion).floatValue > NSString(string: Bundle.current.appVersion).floatValue {
                    return .just(true)
                } else {
                    return .just(false)
                }
                
            }
    }
}
