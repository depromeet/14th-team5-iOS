//
//  JoinFamilyGroupNameEntity.swift
//  Domain
//
//  Created by Kim dohyun on 7/23/24.
//

import Foundation

public struct JoinFamilyGroupNameEntity {
    public let familyid: String
    public let familyName: String
    public let familyNameEditorId: String
    public let familyCreateAt: String
    
    
    public init(
        familyid: String,
        familyName: String,
        familyNameEditorId: String,
        familyCreateAt: String
    ) {
        self.familyid = familyid
        self.familyName = familyName
        self.familyNameEditorId = familyNameEditorId
        self.familyCreateAt = familyCreateAt
    }
}
