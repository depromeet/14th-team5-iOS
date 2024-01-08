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

public struct AccessToken: Codable, Equatable {
    public var accessToken: String?
    public var refreshToken: String?
    public var isTemporaryToken: Bool?
    
    public init(accessToken: String?, refreshToken: String?, isTemporaryToken: Bool?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.isTemporaryToken = isTemporaryToken
    }
}

public extension Data {

    func decode<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> T? where T: Decodable {
        
        let decoder = decoder ?? JSONDecoder()
        
        var res: T? = nil
        do {
            res = try decoder.decode(type, from: self)
        } catch {
            debugPrint("\(T.self) Data Parsing Error: \(error)")
        }
        
        return res
    }
}

public extension String {
    
    func decode<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> T? where T: Decodable {
        return self.data(using: .utf8)?.decode(type, using: decoder)
    }
}

public class TokenRepository: RxObject {
    public let fcmToken = BehaviorRelay<String>(value: KeychainWrapper.standard[.fcmToken] ?? "")
    public let fakeAccessToken = BehaviorRelay<AccessToken?>(value: (KeychainWrapper.standard[.accessToken] as String?)?.decode(AccessToken.self))
    public let accessToken = BehaviorRelay<AccessToken?>(value: (KeychainWrapper.standard[.accessToken] as String?)?.decode(AccessToken.self))
    public func clearAccessToken() {
        KeychainWrapper.standard.remove(forKey: .accessToken)
        accessToken.accept(nil)
    }
    
    public func clearFCMToken() {
        KeychainWrapper.standard.remove(forKey: .fcmToken)
        fcmToken.accept("")
    }
    
    override public func bind() {
        super.bind()
        
        fcmToken
            .distinctUntilChanged()
            .subscribe(on: Schedulers.io)
            .map { ($0, KeychainWrapper.standard[.fcmToken] ?? "") }
            .filter { $0.0 != $0.1 }
            .map { $0.0 }
            .bind(onNext: { KeychainWrapper.standard[.fcmToken] = $0 })
            .disposed(by: self.disposeBag)
        
        fakeAccessToken
            .distinctUntilChanged()
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
            .distinctUntilChanged()
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
    }
    
    override public func unbind() {
        super.unbind()
    }
}
