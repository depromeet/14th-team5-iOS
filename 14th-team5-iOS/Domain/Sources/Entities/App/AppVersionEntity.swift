//
//  AppVersionEntity.swift
//  Domain
//
//  Created by 김건우 on 7/10/24.
//

import Foundation

public struct AppVersionEntity {
    public var appKey: String
    public var appVersion: String
    public var latest: Bool
    public var inReview: Bool
    public var inService: Bool
    
    public init(
        appKey: String,
        appVersion: String,
        latest: Bool,
        inReview: Bool,
        inService: Bool
    ) {
        self.appKey = appKey
        self.appVersion = appVersion
        self.latest = latest
        self.inReview = inReview
        self.inService = inService
    }
}
