//
//  PrivacyAPIWorker.swift
//  Data
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation
import Core
import Alamofire
import Domain
import RxSwift


typealias PrivacyAPIWorker = PrivacyAPIs.Worker



extension PrivacyAPIs {
    final class Worker: APIWorker {
        
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "PrivacyAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "PrivacyAPIWorker"
        }
        
    }
    
}
 

extension PrivacyAPIWorker {
        
    public func requestBibbiAppInfo(accessToken: String, parameter: Encodable) -> Single<BibbiAppInfoDTO?> {
        let spec = PrivacyAPIs.bibbiAppInfo.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], parameters: parameter)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("fetch BibbiApp Info Result: \(str)")
                }
            }
            .map(BibbiAppInfoDTO.self)
            .catchAndReturn(nil)
            .asSingle()
        
    }
    
    public func resignFamily(accessToken: String) -> Single<AccountFamilyResignDTO?> {
        let spec = PrivacyAPIs.accountFamilyResign.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("fetch family resign Reuslt: \(str)")
                }
            }
            .map(AccountFamilyResignDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
}
    
