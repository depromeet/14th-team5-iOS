//
//  SearchFamily.swift
//  Domain
//
//  Created by 마경미 on 24.12.23.
//

import Foundation

public struct ProfileData: Equatable, Hashable, Codable {
    public let memberId: String
    public let profileImageURL: String?
    public let name: String
    public let dayOfBirth: Date
    public var postRank: Int? = nil
    
    public init(memberId: String, profileImageURL: String?, name: String, dayOfBirth: Date = .distantFuture) {
        self.memberId = memberId
        self.profileImageURL = profileImageURL
        self.name = name
        self.dayOfBirth = dayOfBirth
    }
}

public struct SearchFamilyPage: Equatable {
    public let isLast: Bool
    public let members: [ProfileData]
    
    public init(isLast: Bool, members: [ProfileData]) {
        self.isLast = isLast
        self.members = members
    }
}
