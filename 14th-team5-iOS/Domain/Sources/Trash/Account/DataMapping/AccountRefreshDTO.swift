//
//  AccountRefreshDTO.swift
//  Domain
//
//  Created by Kim dohyun on 1/5/24.
//

import Foundation


public struct AccountRefreshDTO: Decodable {
    
    public let accessToken: String
    public let refreshToken: String
    public let isTemporaryToken: Bool
}


extension AccountRefreshDTO {
    public func toDomain() -> AccountRefreshResponse {
        return .init(
            accessToken: accessToken,
            refreshToken: refreshToken,
            isTemporaryToken: isTemporaryToken
        )
    }
}
