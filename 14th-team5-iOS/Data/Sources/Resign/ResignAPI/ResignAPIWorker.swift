//
//  ResignAPIWorker.swift
//  Data
//
//  Created by Kim dohyun on 1/2/24.
//

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
        
        return request(spec: spec, headers: [BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("fetch resign Account Result: \(str)")
                }
            }
            .map(AccountResignDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func resignFcmToken(accessToken: String, fcmToken: String) -> Single<AccountFcmResignDTO?> {
        let spec = ResignAPIs.accountFcmResign(fcmToken).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("fetch resign fcm Result: \(str)")
                }
            }
            .map(AccountFcmResignDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
}
