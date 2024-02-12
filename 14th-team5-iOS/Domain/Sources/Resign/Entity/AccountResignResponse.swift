//
//  AccountResignResponse.swift
//  Domain
//
//  Created by Kim dohyun on 1/2/24.
//

import Foundation

public struct AccountResignResponse {
    public var isSuccess: Bool
    
    public init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
}
