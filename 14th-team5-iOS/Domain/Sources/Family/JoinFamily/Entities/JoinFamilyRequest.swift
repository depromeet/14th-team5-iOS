//
//  JoinFamilyData.swift
//  Domain
//
//  Created by 마경미 on 13.01.24.
//

import Foundation

public struct JoinFamilyRequest {
    public let inviteCode: String
    
    public init(inviteCode: String) {
        self.inviteCode = inviteCode
    }
}
