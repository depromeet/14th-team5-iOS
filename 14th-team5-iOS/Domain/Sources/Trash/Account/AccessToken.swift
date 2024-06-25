//
//  AccessToken.swift
//  Domain
//
//  Created by geonhui Yu on 12/18/23.
//

import Foundation

public struct AccessTokenResponse: Codable, Equatable {
    public var accessToken: String?
    public var refreshToken: String?
    public var isTemporaryToken: Bool?
}
