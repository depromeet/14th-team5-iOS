//
//  AccountRefreshParameter.swift
//  Domain
//
//  Created by Kim dohyun on 1/5/24.
//

import Foundation


public struct AccountRefreshParameter: Encodable {
    
    public var refreshToken: String
    
    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
