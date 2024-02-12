//
//  ProfileMemberResponse.swift
//  Domain
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation


public struct ProfileMemberResponse {
    
    public var memberId: String
    public var memberName: String
    public var memberImage: URL
    public var dayOfBirth: Date
    public var familyJoinAt: String
    
    public init(memberId: String, memberName: String, memberImage: URL, dayOfBirth: Date, familyJoinAt: String) {
        self.memberId = memberId
        self.memberName = memberName
        self.memberImage = memberImage
        self.dayOfBirth = dayOfBirth
        self.familyJoinAt = familyJoinAt
    }
}
