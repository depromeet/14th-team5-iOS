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

    func saveAuthToken(_ authToken: AuthToken?)
    func loadAuthToken() -> AuthToken?
    
    func saveAccessToken(_ accessToken: AccessToken?)
    func loadAccessToken() -> AccessToken?
    
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
    
    
    // MARK: - FCM Token
    
    /// FCM 서버로부터 발급받은 FCM 토큰을 저장합니다.
    public func saveFCMToken(_ fcmToken: String?) {
        keychain[.newFcmToken] = fcmToken
    }
    
    /// FCM 서버로부터 발급받은 FCM 토큰을 저장합니다.
    public func loadFCMToken() -> String? {
        keychain[.newFcmToken]
    }
    
    
    
    // MARK: - Auth AccessToken
    
    public func saveAuthToken(_ authToken: AuthToken?) {
        keychain[.accessToken] = authToken
    }
    
    public func loadAuthToken() -> AuthToken? {
        keychain[.accessToken]
    }
    
    
    
    // MARK: - Old AccessToken
    
    @available(*, deprecated, renamed: "saveAuthToken")
    public func saveAccessToken(_ accessToken: AccessToken?) {
        keychain[.accessToken] = accessToken
    }
    
    @available(*, deprecated, renamed: "loadAuthToken")
    public func loadAccessToken() -> AccessToken? {
        keychain[.accessToken]
    }
    
}
