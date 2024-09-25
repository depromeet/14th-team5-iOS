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
    
    func saveIsTemporaryToken(_ isTemporary: Bool?)
    func loadIsTemporaryToken() -> Bool?
    
    func saveOldAccessToken(_ tokenResult: OldAccessToken?)
    func loadOldAccessToken() -> OldAccessToken?
    
    func saveRefreshToken(_ refreshToken: String?)
    func loadRefreshToken() -> String?
    
    func saveFCMToken(_ fcmToken: String?)
    func loadFCMToken() -> String?
}

final public class TokenKeychain: TokenKeychainType {
    
    // MARK: - Intializer
    public init() { }
    
    
    // MARK: - IdToken
    
    /// 로그인 서버(카카오, 애플)로부터 발급받은 접근 토큰을 저장합니다.
    public func saveIdToken(_ idToken: String?) {
        keychain[.idToken] = idToken
    }
    
    /// 로그인 서버(카카오, 애플)로부터 발급받은 접근 토큰을 불러옵니다.
    public func loadIdToken() -> String? {
        keychain[.idToken]
    }
    
    
    // MARK: - SignInType
    
    /// 로그인 타입(애플, 카카오)를 저장합니다.
    public func saveSignInType(_ type: SignInType?) {
        keychain[.signInType] = type?.rawValue
    }
    
    /// 로그인 타입(애플, 카카오)를 불러옵니다.
    public func loadSignInType() -> SignInType? {
        guard
            let sign: String = keychain[.signInType],
            let type = SignInType(rawValue: sign)
        else { return nil }
        return type
    }
    
    
    // MARK: - AccessToken
    
    /// 삐삐 서버로부터 발급받은 접근 토큰을 저장합니다.
    public func saveAccessToken(_ accessToken: String?) {
        keychain[.newAccessToken] = accessToken
    }
    
    /// 삐삐 서버로부터 발급받은 접근 토큰을 불러옵니다.
    public func loadAccessToken() -> String? {
        keychain[.newAccessToken]
    }
    
    
    // MARK: - RefreshToken
    
    /// 삐삐 서버로부터 발급받은 리프레시 토큰을 저장합니다.
    public func saveRefreshToken(_ refreshToken: String?) {
        keychain[.newRefreshToken] = refreshToken
    }
    
    /// 삐삐 서버로부터 발급받은 리프레시 토큰을 불러옵니다.
    public func loadRefreshToken() -> String? {
        keychain[.newRefreshToken]
    }
    
    
    // MARK: - Is Temporary Token
    
    public func saveIsTemporaryToken(_ isTemporary: Bool?) {
        keychain[.newIsTemporaryToken] = isTemporary
    }
    
    public func loadIsTemporaryToken() -> Bool? {
        keychain[.newIsTemporaryToken]
    }
    
    
    // MARK: - FCM Token
    
    /// FCM 서버로부터 발급받은 FCM 토큰을 저장합니다.
    public func saveFCMToken(_ fcmToken: String?) {
        keychain[.newFcmToken] = fcmToken
    }
    
    /// FCM 서버로부터 발급받은 FCM 토큰을 저장합니다.
    public func loadFCMToken() -> String? {
        keychain[.newFcmToken]
    }
    
    
    
    // MARK: - Old AccessToken
    
    @available(*, deprecated)
    public func saveOldAccessToken(_ tokenResult: OldAccessToken?) {
        guard
            let data = try? JSONEncoder().encode(tokenResult),
            let str = String(data: data, encoding: .utf8)
        else { return }
        keychain[.accessToken] = str
    }
    
    @available(*, deprecated)
    public func loadOldAccessToken() -> OldAccessToken? {
        guard
            let str: String = keychain[.accessToken],
            let data = str.data(using: .utf8),
            let tokenResult = try? JSONDecoder().decode(OldAccessToken.self, from: data)
        else { return nil }
        return tokenResult
    }
    
}
