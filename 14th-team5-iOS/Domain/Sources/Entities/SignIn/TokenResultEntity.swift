//
//  TokenResultEntity.swift
//  Domain
//
//  Created by 김건우 on 6/7/24.
//

import Foundation

public struct TokenResultEntity {
    public var idToken: String // 소셜 로그인용 AccessToken
    
    public init(idToken: String) {
        self.idToken = idToken
    }
}
