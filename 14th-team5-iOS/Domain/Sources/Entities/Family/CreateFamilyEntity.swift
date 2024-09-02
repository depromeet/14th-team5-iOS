//
//  FamilyResponse.swift
//  Domain
//
//  Created by 김건우 on 1/10/24.
//

import Foundation

public struct CreateFamilyEntity {
    public var familyId: String
    public var createdAt: Date
    
    public init(familyId: String, createdAt: Date) {
        self.familyId = familyId
        self.createdAt = createdAt
    }
}
