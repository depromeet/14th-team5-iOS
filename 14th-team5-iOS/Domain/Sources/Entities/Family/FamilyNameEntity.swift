//
//  FamilyNameEntity.swift
//  Domain
//
//  Created by 김건우 on 8/11/24.
//

import Foundation

public struct FamilyNameEntity {
    public var familyId: String
    public var familyName: String
    public var familyNameEditorId: String
    public var createdAt: Date
    
    public init(
        familyId: String,
        familyName: String,
        familyNameEditorId: String,
        createdAt: Date
    ) {
        self.familyId = familyId
        self.familyName = familyName
        self.familyNameEditorId = familyNameEditorId
        self.createdAt = createdAt
    }
}
