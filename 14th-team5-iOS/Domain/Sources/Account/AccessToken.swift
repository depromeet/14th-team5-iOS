//
//  AccessToken.swift
//  Domain
//
//  Created by geonhui Yu on 12/18/23.
//

import Foundation

public struct AccessToken: Codable, Equatable {
    var accessToken: String?
    var refreshToken: String?
    var isTemporaryToken: Bool?
}
