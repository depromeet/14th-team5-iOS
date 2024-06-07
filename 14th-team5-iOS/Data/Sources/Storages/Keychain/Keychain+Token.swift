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
        keychain[.accessToken] = accessToken
    }
    
    public func loadAccessToken() -> String? {
        keychain[.accessToken]
    }
    
    
    // MARK: - RefreshToken
    public func saveRefreshToken(_ refreshToken: String?) {
        keychain[.refreshToken] = refreshToken
    }
    
    public func loadRefreshToken() -> String? {
        keychain[.refreshToken]
    }
    
    
    // MARK: - FCM Token
    public func saveFCMToken(_ fcmToken: String?) {
        keychain[.fcmToken] = fcmToken
    }
    
    public func loadFCMToken() -> String? {
        keychain[.fcmToken]
    }
    
}
