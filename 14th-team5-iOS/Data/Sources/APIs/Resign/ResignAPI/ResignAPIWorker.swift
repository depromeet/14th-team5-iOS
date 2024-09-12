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
    
    public func resignUser(memberId: String) -> Single<AccountResignResponseDTO?> {
        let spec = ResignAPIs.accountResign(memberId).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .map(AccountResignResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
}
