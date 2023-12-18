//
//  AccountSignInStateInfo.swift
//  Domain
//
//  Created by geonhui Yu on 12/18/23.
//

import Foundation

public struct AccountSignInStateInfo: Equatable {
    public let snsType: SNS
    public var snsToken: String?
    
    public init(snsType: SNS, snsToken: String? = nil) {
        self.snsType = snsType
        self.snsToken = snsToken
    }
}
