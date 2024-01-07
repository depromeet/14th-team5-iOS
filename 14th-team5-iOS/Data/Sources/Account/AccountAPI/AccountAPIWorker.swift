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
        
        // MARK: Values
        private var _headers: Observable<[APIHeader]?> {
            return App.Repository.token.fakeAccessToken
                .map {
                    guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                    return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken)]
                }
        }
    }
}

// MARK: SignIn
extension AccountAPIWorker {
    private func signInWith(spec: APISpec, jsonEncodable: Encodable) -> Single<AccessTokenResponse?> {
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey], jsonEncodable: jsonEncodable)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("SignIn result : \(str)")
                }
            })
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
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("SignUp result : \(str)")
                }
            })
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
    
    func updateProfileNickName(accessToken: String, memberId: String, parameter: Encodable) -> Single<AccountNickNameEditDTO?> {
        let spec = AccountAPIs.profileNickNameEdit(memberId).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken), BibbiAPI.Header.acceptJson], jsonEncodable: parameter)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Account nickName update Result: \(str)")
                }
            }
            .map(AccountNickNameEditDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    func accountRefreshToken(parameter: Encodable) -> Single<AccountRefreshDTO?> {
        let spec = AccountAPIs.refreshToken.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.contentJson] ,jsonEncodable: parameter)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Account Refresh Token Result \(str)")
                }
            }
            .map(AccountRefreshDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
}
