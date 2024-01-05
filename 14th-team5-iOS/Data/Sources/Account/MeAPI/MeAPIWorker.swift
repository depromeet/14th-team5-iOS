//
//  MeAPIWorker.swift
//  Data
//
//  Created by geonhui Yu on 1/3/24.
//

import Foundation
import Domain
import Core

import RxSwift
import Alamofire

fileprivate typealias _PayLoad = MeAPIs.PayLoad
typealias MeAPIWorker = MeAPIs.Worker
extension MeAPIs {
    
    final class Worker: APIWorker {
        
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "MeAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "MeAPIWorker"
        }
    }
}

// MARK: SignIn
extension MeAPIWorker {
    private func saveFcmToken(spec: APISpec, jsonEncodable: Encodable) -> Single<String?> {
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("saveFcmToken result : \(str)")
                }
            })
            .map(String.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    func saveFcmToken(token: String) -> Single<String?> {
        let spec = MeAPIs.saveFcmToken.spec
        let payload = _PayLoad.FcmPayload(fcmToken: token)
        
        return saveFcmToken(spec: spec, jsonEncodable: payload)
    }
    
    private func deleteFcmToken(spec: APISpec) -> Single<String?> {
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("deleteFcmToken result : \(str)")
                }
            })
            .map(String.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    func deleteFcmToken(token: String) -> Single<String?> {
        let spec = MeAPIs.deleteFcmToken(token).spec
        return deleteFcmToken(spec: spec)
    }
    
    private func getMemberInfo(spec: APISpec) -> Single<MemberInfo?> {
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("getMemberInfo result : \(str)")
                }
            })
            .map(MemberInfo.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    func getMemberInfo() -> Single<MemberInfo?> {
        let spec = MeAPIs.memberInfo.spec
        return getMemberInfo(spec: spec)
    }
}
