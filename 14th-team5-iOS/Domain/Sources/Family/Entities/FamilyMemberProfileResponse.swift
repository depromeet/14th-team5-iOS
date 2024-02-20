//
//  FamiliyMember.swift
//  Domain
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

public struct PaginationResponseFamilyMemberProfile {
    public var results: [ProfileData]
    
    public init(results: [ProfileData]) {
        self.results = results
    }
}

public struct ProfileData: Equatable, Hashable, Codable {
    public let memberId: String
    public let profileImageURL: String?
    public let name: String
    public let dayOfBirth: Date
    public var postRank: Int? = nil
    
    public init(
        memberId: String,
        profileImageURL: String? = nil,
        name: String,
        dayOfBirth: Date = .distantFuture
    ) {
        self.memberId = memberId
        self.profileImageURL = profileImageURL
        self.name = name
        self.dayOfBirth = dayOfBirth
    }
}

@available(*, deprecated, renamed: "PaginationResponseFamilyMemberProfile")
public struct SearchFamilyPage: Equatable {
    public let isLast: Bool
    public let members: [ProfileData]
    
    public init(isLast: Bool, members: [ProfileData]) {
        self.isLast = isLast
        self.members = members
    }
}

//public struct FamilyMemberProfileResponse {
//    public var memberId: String
//    public var name: String
//    public var imageUrl: String?
//    public var dayOfBirth: Date
//    
//    public init(memberId: String, name: String, imageUrl: String? = nil, dayOfBirth: Date = .distantFuture) {
//        self.memberId = memberId
//        self.name = name
//        self.imageUrl = imageUrl
//        self.dayOfBirth = dayOfBirth
//    }
//}
