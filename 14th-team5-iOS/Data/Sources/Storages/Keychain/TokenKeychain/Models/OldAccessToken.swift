//
//  AccessToken.swift
//  Data
//
//  Created by 김건우 on 8/24/24.
//

import Foundation

public struct OldAccessToken: Codable, Equatable {
    
    public let accessToken: String?
    public let refreshToken: String?
    public let isTemporaryToken: Bool?
    
    public init(
        accessToken: String?,
        refreshToken: String?,
        isTemporaryToken: Bool?
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.isTemporaryToken = isTemporaryToken
    }
}
