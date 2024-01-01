//
//  PrivacyAPIWorker.swift
//  Data
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation

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
        
    public func requestStoreInfo(parameter: Encodable) -> Single<BibbiStoreInfoDTO?> {
        let spec = PrivacyAPIs.storeDetail.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.acceptJson], parameters: parameter)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("fetch Store Detail Result: \(str)")
                }
            }
            .map(BibbiStoreInfoDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
}
    
