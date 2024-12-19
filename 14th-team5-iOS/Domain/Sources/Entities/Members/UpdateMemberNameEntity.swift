//
//  UpdateMemberNameEntity.swift
//  Domain
//
//  Created by 김도현 on 11/21/24.
//

import Foundation


public struct UpdateMemberNameEntity {
    public let memberId: String
    public let name: String
    public let imageUrl: URL
    public let familyId: String
    public let familyJoinAt: String
    public let dayOfBirth: String
    
    public init(
        memberId: String,
        name: String,
        imageUrl: URL,
        familyId: String,
        familyJoinAt: String,
        dayOfBirth: String
    ) {
        self.memberId = memberId
        self.name = name
        self.imageUrl = imageUrl
        self.familyId = familyId
        self.familyJoinAt = familyJoinAt
        self.dayOfBirth = dayOfBirth
    }
}
