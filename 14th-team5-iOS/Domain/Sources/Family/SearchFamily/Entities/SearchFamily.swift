//
//  SearchFamily.swift
//  Domain
//
//  Created by 마경미 on 24.12.23.
//

import Foundation

public struct SearchFamily: Equatable, Identifiable {
    public let id: Int
    let memberId: String
    let profileImageURL: String
    let name: String
    
    public init(id: Int, memberId: String, profileImageURL: String, name: String) {
        self.id = id
        self.memberId = memberId
        self.profileImageURL = profileImageURL
        self.name = name
    }
}

public struct SearchFamilyPage: Equatable {
    let page: Int
    let totalPages: Int
    let members: [SearchFamily]
    
    public init(page: Int, totalPages: Int, members: [SearchFamily]) {
        self.page = page
        self.totalPages = totalPages
        self.members = members
    }
}
