//
//  ResignAPIWorker.swift
//  Data
//
//  Created by Kim dohyun on 1/2/24.
//

import Core
import Foundation

import Alamofire
import Domain
import RxSwift


typealias ResignAPIWorker = ResignAPIs.Worker

extension ResignAPIs {
    final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "ResignAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "ResignAPIWorker"
        }
    }
}


extension ResignAPIWorker {
    
    public func resignUser(accessToken: String, memberId: String) -> Single<AccountResignDTO?> {
        let spec = ResignAPIs.accountResign(memberId).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
            .subscribe(on: Self.queue)
            .map(AccountResignDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
}
