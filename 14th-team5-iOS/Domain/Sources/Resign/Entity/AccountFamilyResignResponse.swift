//
//  AccountFamilyResignResponse.swift
//  Domain
//
//  Created by Kim dohyun on 1/17/24.
//

import Foundation

public struct AccountFamilyResignResponse {
    public var isSuccess: Bool
    
    public init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
}
