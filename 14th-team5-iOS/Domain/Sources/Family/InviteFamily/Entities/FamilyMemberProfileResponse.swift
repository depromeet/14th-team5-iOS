//
//  FamiliyMember.swift
//  Domain
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

public struct PaginationResponseFamilyMemberProfile {
    public var results: [FamilyMemberProfileResponse]
    
    public init(results: [FamilyMemberProfileResponse]) {
        self.results = results
    }
}

public struct FamilyMemberProfileResponse {
    public var memberId: String
    public var name: String
    public var imageUrl: String?
    public var dayOfBirth: Date
    
    public init(memberId: String, name: String, imageUrl: String? = nil, dateOfBirth: Date) {
        self.memberId = memberId
        self.name = name
        self.imageUrl = imageUrl
        self.dayOfBirth = dateOfBirth
    }
}
