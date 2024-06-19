//
//  AuthResultEntity.swift
//  Domain
//
//  Created by 김건우 on 6/6/24.
//

import Foundation

public struct AuthResultEntity {
    public var refreshToken: String?
    public var accessToken: String?
    public var isTemporaryToken: Bool?
    
    public init(
        refreshToken: String?,
        accessToken: String?,
        isTemporaryToken: Bool?
    ) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
        self.isTemporaryToken = isTemporaryToken
    }
}
