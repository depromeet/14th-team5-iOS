//
//  AppVersion.swift
//  Domain
//
//  Created by geonhui Yu on 2/10/24.
//

import Foundation

public struct AppVersionInfo: Codable, Equatable {
    public var appKey: String
    public var appVersion: String
    var latest: Bool
    var inReview: Bool
    public var inService: Bool
}
