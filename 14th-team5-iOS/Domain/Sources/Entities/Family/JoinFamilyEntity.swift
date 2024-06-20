//
//  JoinFamilyData.swift
//  Domain
//
//  Created by 마경미 on 13.01.24.
//

import Foundation

public struct JoinFamilyEntity {
    public var familyId: String
    public var createdAt: Date
    
    public init(familyId: String, createdAt: Date) {
        self.familyId = familyId
        self.createdAt = createdAt
    }
}
