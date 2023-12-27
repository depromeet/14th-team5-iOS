//
//  AccountAPIWorker.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import Foundation
import Domain

import RxSwift
import Alamofire

fileprivate typealias _PayLoad = AccountAPIs.PayLoad
typealias AccountAPIWorker = AccountAPIs.Worker
extension AccountAPIs {
    
    final class Worker: APIWorker {
        
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "AccountAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "AccountAPIWorker"
        }
    }
}

// MARK: SignIn
extension AccountAPIWorker {
    
    private func signUpWith(spec: APISpec, jsonEncodable: Encodable) -> Single<AccessToken?> {
        return request(spec: spec, jsonEncodable: jsonEncodable)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("SignUp result : \(str)")
                }
            })
            .map(BibbiCodableResponse<AccessToken>.self)
            .catchAndReturn(nil)
            .map { $0?.result }
            .asSingle()
    }
    
    private func signInWith(spec: APISpec, jsonEncodable: Encodable) -> Single<AccessToken?> {
        return request(spec: spec, jsonEncodable: jsonEncodable)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("SignIn result : \(str)")
                }
            })
            .map(BibbiCodableResponse<AccessToken>.self)
            .catchAndReturn(nil)
            .map { $0?.result }
            .asSingle()
    }
    
    func signInWith(snsType: SNS, snsToken: String) -> Single<AccessToken?> {
        let spec = AccountAPIs.signIn(snsType).spec
        let payload = _PayLoad.LoginPayload(accessToken: snsToken)
        
        return signInWith(spec: spec, jsonEncodable: payload)
    }
    
    func signUpWith(name: String?, date: String?, photoURL: String?) -> Single<AccessToken?> {
        let spec = AccountAPIs.signUp.spec
        let payLoad = _PayLoad.AccountSignUpPayLoad(memberName: name, dayOfBirth: date, profileImgUrl: photoURL)
        
        return signUpWith(spec: spec, jsonEncodable: payLoad)
    }
}
