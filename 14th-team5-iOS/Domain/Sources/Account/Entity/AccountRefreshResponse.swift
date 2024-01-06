//
//  AccountRefreshResponse.swift
//  Domain
//
//  Created by Kim dohyun on 1/5/24.
//

import Foundation


public struct AccountRefreshResponse {
    public let accessToken: String
    public let refreshToken: String
    public let isTemporaryToken: Bool
}
