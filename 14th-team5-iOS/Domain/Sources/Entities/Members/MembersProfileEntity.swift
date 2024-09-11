//
//  MembersProfileEntity.swift
//  Domain
//
//  Created by Kim dohyun on 6/15/24.
//

import Foundation

public struct MembersProfileEntity {
    public let memberId: String
    public let memberName: String
    public let memberImage: URL
    public let dayOfBirth: Date
    public let familyJoinAt: String
    
    
    public init(
        memberId: String,
        memberName: String,
        memberImage: URL,
        dayOfBirth: Date,
        familyJoinAt: String
    ) {
        self.memberId = memberId
        self.memberName = memberName
        self.memberImage = memberImage
        self.dayOfBirth = dayOfBirth
        self.familyJoinAt = familyJoinAt
    }
}
