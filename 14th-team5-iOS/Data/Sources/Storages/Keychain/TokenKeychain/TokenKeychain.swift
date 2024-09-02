//
//  Keychain+Token.swift
//  Data
//
//  Created by 김건우 on 6/2/24.
//

import Core
import Domain
import Foundation

public protocol TokenKeychainType: KeychainType {
    func saveIdToken(_ idToken: String?)
    func loadIdToken() -> String?
    
    func saveSignInType(_ type: SignInType?)
    func loadSignInType() -> SignInType?
    
    func saveAccessToken(_ accessToken: String?)
    func loadAccessToken() -> String?
    
    func saveOldAccessToken(_ tokenResult: AccessToken?)
    func loadOldAccessToken() -> AccessToken?
    
    func saveRefreshToken(_ refreshToken: String?)
    func loadRefreshToken() -> String?
    
    func saveFCMToken(_ fcmToken: String?)
    func loadFCMToken() -> String?
}

final public class TokenKeychain: TokenKeychainType {
    
    // MARK: - Intializer
    public init() { }
    
    
    // MARK: - IdToken
    public func saveIdToken(_ idToken: String?) {
        keychain[.idToken] = idToken
    }
    
    public func loadIdToken() -> String? {
        keychain[.idToken]
    }
    
    
    // MARK: - SignInType
    public func saveSignInType(_ type: SignInType?) {
        keychain[.signInType] = type?.rawValue
    }
    
    public func loadSignInType() -> SignInType? {
        guard
            let sign: String = keychain[.signInType],
            let type = SignInType(rawValue: sign)
        else { return nil }
        return type
    }
    
    
    // MARK: - AccessToken
    public func saveAccessToken(_ accessToken: String?) {
        keychain[.newAccessToken] = accessToken
    }
    
    public func loadAccessToken() -> String? {
        keychain[.newAccessToken]
    }
    
    
    // MARK: - Old AccessToken
    public func saveOldAccessToken(_ tokenResult: AccessToken?) {
        // AccessToken은 Core 모듈의 TokenRepository에 정의되어 있음
        guard
            let data = try? JSONEncoder().encode(tokenResult),
            let str = String(data: data, encoding: .utf8)
        else { return }
        keychain[.accessToken] = str
    }
    
    public func loadOldAccessToken() -> AccessToken? {
        guard
            let str: String = keychain[.accessToken],
            let data = str.data(using: .utf8),
            let tokenResult = try? JSONDecoder().decode(AccessToken.self, from: data)
        else { return nil }
        return tokenResult
    }
    
    
    // MARK: - RefreshToken
    public func saveRefreshToken(_ refreshToken: String?) {
        keychain[.newRefreshToken] = refreshToken
    }
    
    public func loadRefreshToken() -> String? {
        keychain[.newRefreshToken]
    }
    
    
    // MARK: - FCM Token
    public func saveFCMToken(_ fcmToken: String?) {
        keychain[.newFcmToken] = fcmToken
    }
    
    public func loadFCMToken() -> String? {
        keychain[.newFcmToken]
    }
    
}
