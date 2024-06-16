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
    static let accessToken: Self = "accessToken"
    static let refreshToken: Self = "refreshToken"
    static let fcmToken: Self = "fcmToken"
    
}
