//
//  TokenRepository.swift
//  Core
//
//  Created by geonhui Yu on 12/14/23.
//

import Foundation

import RxSwift
import RxCocoa
import SwiftKeychainWrapper

fileprivate extension KeychainWrapper.Key {
    static let fcmToken: KeychainWrapper.Key = "FCMToken"
    static let fakeAccessToken: KeychainWrapper.Key = "fakeAccessToken"
    static let accessToken: KeychainWrapper.Key = "accessToken"
    static let refreshToken: KeychainWrapper.Key = "refreshToken"
}

public class TokenRepository: RxObject {
    public let fcmToken = BehaviorRelay<String>(value: KeychainWrapper.standard[.fcmToken] ?? "")
    public let fakeAccessToken = BehaviorRelay<String?>(value: (KeychainWrapper.standard[.fakeAccessToken] ?? ""))
    public let accessToken = BehaviorRelay<String?>(value: (KeychainWrapper.standard[.accessToken] ?? ""))
    public let refreshToken = BehaviorRelay<String?>(value: KeychainWrapper.standard[.refreshToken] ?? "")
    
    func clearAccessToken() {
        KeychainWrapper.standard.remove(forKey: .accessToken)
        accessToken.accept(nil)
    }
    
    func clearFCMToken() {
        KeychainWrapper.standard.remove(forKey: .fcmToken)
        fcmToken.accept("")
    }
    
    func clearRefreshToken() {
        KeychainWrapper.standard.remove(forKey: .refreshToken)
        refreshToken.accept("")
    }
    
    override public func bind() {
        super.bind()
        
        fcmToken
            .subscribe(on: Schedulers.io)
            .map { ($0, KeychainWrapper.standard[.fcmToken] ?? "") }
            .filter { $0.0 != $0.1 }
            .map { $0.0 }
            .bind(onNext: { KeychainWrapper.standard[.fcmToken] = $0 })
            .disposed(by: self.disposeBag)
        
        fakeAccessToken
            .subscribe(on: Schedulers.io)
            .withUnretained(self)
            .subscribe {
                guard let jsonData = try? JSONEncoder().encode($0.1),
                      let jsonStr = String(data: jsonData, encoding: .utf8) else {
                    KeychainWrapper.standard.remove(forKey: .fakeAccessToken)
                    return
                }
                KeychainWrapper.standard[.fakeAccessToken] = jsonStr
            }
            .disposed(by: disposeBag)
        
        accessToken
            .subscribe(on: Schedulers.io)
            .withUnretained(self)
            .subscribe {
                guard let jsonData = try? JSONEncoder().encode($0.1),
                      let jsonStr = String(data: jsonData, encoding: .utf8) else {
                    KeychainWrapper.standard.remove(forKey: .accessToken)
                    return
                }
                KeychainWrapper.standard[.accessToken] = jsonStr
            }
            .disposed(by: disposeBag)
        
        refreshToken
            .subscribe(on: Schedulers.io)
            .withUnretained(self)
            .subscribe {
                guard let jsonData = try? JSONEncoder().encode($0.1),
                      let jsonStr = String(data: jsonData, encoding: .utf8) else {
                    KeychainWrapper.standard.remove(forKey: .refreshToken)
                    return
                }
                KeychainWrapper.standard[.refreshToken] = jsonStr
            }.disposed(by: disposeBag)

 
    }
    
    override public func unbind() {
        super.unbind()
    }
}
