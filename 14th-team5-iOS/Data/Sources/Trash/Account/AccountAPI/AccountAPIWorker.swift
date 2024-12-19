//
//  AccountAPIWorker.swift
//  Data
//
//  Created by geonhui Yu on 12/18/23.
//

import Foundation
import Domain
import Core

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
    private func signInWith(spec: APISpec, jsonEncodable: Encodable) -> Single<AccessTokenResponse?> {
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey], jsonEncodable: jsonEncodable)
            .subscribe(on: Self.queue)
            .map(AccessTokenResponse.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    func signInWith(snsType: SNS, snsToken: String) -> Single<AccessTokenResponse?> {
        let spec = AccountAPIs.signIn(snsType).spec
        let payload = _PayLoad.LoginPayload(accessToken: snsToken)
        
        return signInWith(spec: spec, jsonEncodable: payload)
    }
    
    private func signUpWith(headers: [APIHeader]?, jsonEncodable: Encodable) -> Single<AccessTokenResponse?> {
        
        let spec = AccountAPIs.signUp.spec
        
        return request(spec: spec, headers: headers, jsonEncodable: jsonEncodable)
            .subscribe(on: Self.queue)
            .map(AccessTokenResponse.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    func signUpWith(name: String?, date: String?, photoURL: String?) -> Single<AccessTokenResponse?> {
        let payLoad = _PayLoad.AccountSignUpPayLoad(memberName: name, dayOfBirth: date, profileImgUrl: photoURL)
        
        return Observable.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.signUpWith(headers: $1, jsonEncodable: payLoad) }
            .asSingle()
    }
    
    func accountRefreshToken(parameter: Encodable) -> Single<AccountRefreshDTO?> {
        let spec = AccountAPIs.refreshToken.spec
        print("RefreshToken: \(parameter)")
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.contentJson], jsonEncodable: parameter)
            .subscribe(on: Self.queue)
            .map(AccountRefreshDTO.self)
            .asSingle()
    }
}
