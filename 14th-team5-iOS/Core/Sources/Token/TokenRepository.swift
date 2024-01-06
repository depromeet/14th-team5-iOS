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
}

public class TokenRepository: RxObject {
    public let fcmToken = BehaviorRelay<String>(value: KeychainWrapper.standard[.fcmToken] ?? "")
    //    public let fakeAccessToken = BehaviorRelay<String?>(value: (KeychainWrapper.standard[.fakeAccessToken]))
    //    public let accessToken = BehaviorRelay<String?>(value: (KeychainWrapper.standard[.accessToken]))
    public let fakeAccessToken = BehaviorRelay<String?>(value: nil)
    public let accessToken = BehaviorRelay<String?>(value: nil)
    
    func clearAccessToken() {
        KeychainWrapper.standard.remove(forKey: .accessToken)
        accessToken.accept(nil)
    }
    
    func clearFCMToken() {
        KeychainWrapper.standard.remove(forKey: .fcmToken)
        fcmToken.accept("")
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
            .bind(onNext: { (owner, value) in
                do {
                    if let value = value {
                        let jsonData = try JSONEncoder().encode(value)
                        if let jsonStr = String(data: jsonData, encoding: .utf8) {
                            print("jsonStr: \(jsonStr)")
                            KeychainWrapper.standard[.fakeAccessToken] = jsonStr
                        } else {
                            print("Failed to convert JSON data to string.")
                            KeychainWrapper.standard.remove(forKey: .fakeAccessToken)
                        }
                    } else {
                        print("Value is nil.")
                        KeychainWrapper.standard.remove(forKey: .fakeAccessToken)
                    }
                } catch {
                    print("Error encoding value to JSON: \(error)")
                    KeychainWrapper.standard.remove(forKey: .fakeAccessToken)
                }
            })
            .disposed(by: disposeBag)
        
        accessToken
            .subscribe(on: Schedulers.io)
            .withUnretained(self)
            .bind(onNext: { (owner, value) in
                do {
                    if let value = value {
                        let jsonData = try JSONEncoder().encode(value)
                        if let jsonStr = String(data: jsonData, encoding: .utf8) {
                            print("jsonStr: \(jsonStr)")
                            KeychainWrapper.standard[.fakeAccessToken] = jsonStr
                        } else {
                            print("Failed to convert JSON data to string.")
                            KeychainWrapper.standard.remove(forKey: .fakeAccessToken)
                        }
                    } else {
                        print("Value is nil.")
                        KeychainWrapper.standard.remove(forKey: .fakeAccessToken)
                    }
                } catch {
                    print("Error encoding value to JSON: \(error)")
                    KeychainWrapper.standard.remove(forKey: .fakeAccessToken)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override public func unbind() {
        super.unbind()
    }
}
