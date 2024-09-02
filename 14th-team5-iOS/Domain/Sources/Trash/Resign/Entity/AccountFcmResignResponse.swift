//
//  AccountFcmResignResponse.swift
//  Domain
//
//  Created by Kim dohyun on 1/5/24.
//

import Foundation


public struct AccountFcmResignResponse {
    public var isSuccess: Bool
    
    public init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
}
