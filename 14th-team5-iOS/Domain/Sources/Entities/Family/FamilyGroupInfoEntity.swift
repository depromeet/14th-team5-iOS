//
//  FamilyGroupInfoEntity.swift
//  Domain
//
//  Created by Kim dohyun on 9/6/24.
//

import Foundation

public struct FamilyGroupInfoEntity {
    public let familyId: String
    public let familyName: String?
    public let familyNameEditorId: String?
    public let createdAt: Date
    
    
    public init(
        familyId: String,
        familyName: String?,
        familyNameEditorId: String?,
        createdAt: Date
    ) {
        self.familyId = familyId
        self.familyName = familyName
        self.familyNameEditorId = familyNameEditorId
        self.createdAt = createdAt
    }
}
