//
//  FamiliyMember.swift
//  Domain
//
//  Created by 김건우 on 12/20/23.
//

import Foundation

public struct FamiliyMemberPage {
    public var members: [FamiliyMember]
    
    public init(members: [FamiliyMember]) {
        self.members = members
    }
}

public struct FamiliyMember {
    public var memberId: String
    public var name: String
    public var imageUrl: String?
    
    public init(memberId: String, name: String, imageUrl: String? = nil) {
        self.memberId = memberId
        self.name = name
        self.imageUrl = imageUrl
    }
}
