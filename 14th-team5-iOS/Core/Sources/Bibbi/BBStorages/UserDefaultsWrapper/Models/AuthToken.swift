//
//  AuthToken.swift
//  Core
//
//  Created by 김건우 on 10/3/24.
//

import Foundation

public struct AuthToken: Codable {
    
    public let accessToken: String
    public let refreshToken: String
    public let isTemporaryToken: Bool
    
    public init(accessToken: String, refreshToken: String, isTemporaryToken: Bool) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.isTemporaryToken = isTemporaryToken
    }
    
}

extension AuthToken: Equatable { }
