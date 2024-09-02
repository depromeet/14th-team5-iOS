//
//  BibbiAppInfoResponse.swift
//  Domain
//
//  Created by Kim dohyun on 1/17/24.
//

import Foundation


public struct BibbiAppInfoResponse {
    public var appKey: String
    public var appVersion: String
    public var latest: Bool
    
    public init(appKey: String, appVersion: String, latest: Bool) {
        self.appKey = appKey
        self.appVersion = appVersion
        self.latest = latest
    }
}
