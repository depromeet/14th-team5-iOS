//
//  KeychainWrapperKey.swift
//  KeychainWrapper
//
//  Created by 김건우 on 5/14/24.
//

import Foundation

public extension KeychainWrapper.Key {
    
    // MARK: - SignIn
    
    static let signInType: Self = "signInType"
    static let idToken: Self = "idToken" // 소셜 로그인의 AccessToken
    
    
    // MARK: - OAuth
    
    static let newAccessToken: Self = "newAccessToken"
    static let newRefreshToken: Self = "newRefreshToken"
    static let newIsTemporaryToken: Self = "newIsTemporaryToken"
    static let newFcmToken: Self = "newFcmToken"
    
    
    
    
    // MARK: - Old OAuth Key (Deprecated)
    static let accessToken: Self = "accessToken"
    static let fcmToken: Self = "fcmToken"
    
}
