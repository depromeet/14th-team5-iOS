//
//  FamilyCreatedAtResponse.swift
//  Domain
//
//  Created by 김건우 on 1/6/24.
//

import Foundation

public struct FamilyCreatedAtResponse {
    var createdAt: Date
    
    public init(createdAt: Date) {
        self.createdAt = createdAt
    }
}
