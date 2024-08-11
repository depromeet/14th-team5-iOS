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
    public var familyIdEditorId: String
    public var createdAt: Date
    
    public init(
        familyId: String,
        familyName: String,
        familyIdEditorId: String,
        createdAt: Date
    ) {
        self.familyId = familyId
        self.familyName = familyName
        self.familyIdEditorId = familyIdEditorId
        self.createdAt = createdAt
    }
}
