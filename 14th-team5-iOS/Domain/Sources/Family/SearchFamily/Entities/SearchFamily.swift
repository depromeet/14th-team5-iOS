//
//  SearchFamily.swift
//  Domain
//
//  Created by 마경미 on 24.12.23.
//

import Foundation

public struct ProfileData: Equatable {
    public let memberId: String
    public let profileImageURL: String
    public let name: String
    
    public init(memberId: String, profileImageURL: String, name: String) {
        self.memberId = memberId
        self.profileImageURL = profileImageURL
        self.name = name
    }
}

public struct SearchFamilyPage: Equatable {
    let page: Int
    let totalPages: Int
    public let members: [ProfileData]
    
    public init(page: Int, totalPages: Int, members: [ProfileData]) {
        self.page = page
        self.totalPages = totalPages
        self.members = members
    }
}
