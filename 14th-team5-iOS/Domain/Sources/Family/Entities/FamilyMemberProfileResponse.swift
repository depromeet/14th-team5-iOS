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
    public let dayOfBirth: Date?
    public let isShowBirthdayMark: Bool
    public let isShowPickIcon: Bool
    public var postRank: Int? = nil
    
    public init(
        memberId: String,
        profileImageURL: String? = nil,
        name: String,
        dayOfBirth: Date? = .distantFuture,
        isShowBirthdayMark: Bool = false,
        isShowPickIcon: Bool = false,
        postRank: Int? = nil
    ) {
        self.memberId = memberId
        self.profileImageURL = profileImageURL
        self.name = name
        self.dayOfBirth = dayOfBirth
        self.isShowBirthdayMark = isShowBirthdayMark
        self.isShowPickIcon = isShowPickIcon
        self.postRank = postRank
    }
}
