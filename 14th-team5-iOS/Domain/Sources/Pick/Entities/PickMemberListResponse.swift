//
//  PickMemberListResponseDTO.swift
//  Domain
//
//  Created by 김건우 on 4/15/24.
//

import Foundation

public struct PickMemberListResponse {
    public var results: [PickMember]
    
    public init(results: [PickMember]) {
        self.results = results
    }
}

public struct PickMember {
    public var memberId: String
    public var name: String
    public var imageUrl: String
    public var familyId: String
    public var familyJoinedAt: Date
    public var dayOfBirth: Date
    
    public init(
        memberId: String,
        name: String,
        imageUrl: String,
        familyId: String,
        familyJoinedAt: Date,
        dayOfBirth: Date
    ) {
        self.memberId = memberId
        self.name = name
        self.imageUrl = imageUrl
        self.familyId = familyId
        self.familyJoinedAt = familyJoinedAt
        self.dayOfBirth = dayOfBirth
    }
}
