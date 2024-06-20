//
//  FamilyCreatedAtResponse.swift
//  Domain
//
//  Created by 김건우 on 2/20/24.
//

import Foundation

public struct FamilyCreatedAtEntity {
    public var createdAt: Date
    
    public init(createdAt: Date) {
        self.createdAt = createdAt
    }
}
