//
//  MemberProfileResponse.swift
//  Domain
//
//  Created by Kim dohyun on 6/3/24.
//

import Foundation


public struct MembersProfileResponse {
    public let memberId: String
    public let memberName: String
    public let memberImage: URL
    public let dayOfBirth: Date
    public let familyJoinAt: String
    
 
    public init(memberId: String, memberName: String, memberImage: URL, dayOfBirth: Date, familyJoinAt: String) {
        self.memberId = memberId
        self.memberName = memberName
        self.memberImage = memberImage
        self.dayOfBirth = dayOfBirth
        self.familyJoinAt = familyJoinAt
    }
}
