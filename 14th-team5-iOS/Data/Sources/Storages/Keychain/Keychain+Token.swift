//
//  Keychain+Token.swift
//  Data
//
//  Created by 김건우 on 6/2/24.
//

import Core
import Foundation


// NOTE: - 예시 코드

final public class TokenKeychain: KeychainType {
    
    // MARK: - Intializer
    public init() { }
    
    
    // MARK: - AccessToken
    public func saveAccessToken(_ accessToken: String) {
        keychain[.accessToken] = accessToken
    }
    
    public func loadAccessToken() -> String? {
        keychain[.accessToken]
    }
    
    // ...
    
}
