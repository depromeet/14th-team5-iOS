//
//  FamiliyMember.swift
//  Domain
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

public typealias Profile = FamilyMemberProfileEntity

public struct PaginationResponseFamilyMemberProfileEntity {
    public var results: [FamilyMemberProfileEntity]
    
    public init(results: [FamilyMemberProfileEntity]) {
        self.results = results
    }
}

public struct FamilyMemberProfileEntity: Equatable, Hashable, Codable {
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
        name: String? = nil,
        dayOfBirth: Date? = .distantFuture,
        isShowBirthdayMark: Bool = false,
        isShowPickIcon: Bool = false,
        postRank: Int? = nil
    ) {
        self.memberId = memberId
        self.profileImageURL = profileImageURL
        self.name = name ?? "알 수 없음"
        self.dayOfBirth = dayOfBirth
        self.isShowBirthdayMark = isShowBirthdayMark
        self.isShowPickIcon = isShowPickIcon
        self.postRank = postRank
    }
}
