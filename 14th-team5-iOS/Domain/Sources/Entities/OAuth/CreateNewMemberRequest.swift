//
//  CreateNewMemberRequest.swift
//  Domain
//
//  Created by 김건우 on 6/6/24.
//

import Foundation

public struct CreateNewMemberRequest {
    public var memberName: String
    public var dayOfBirth: String
    public var profileImageUrl: String
    
    public init(
        memberName: String,
        dayOfBirth: String,
        profileImageUrl: String
    ) {
        self.memberName = memberName
        self.dayOfBirth = dayOfBirth
        self.profileImageUrl = profileImageUrl
    }
}
