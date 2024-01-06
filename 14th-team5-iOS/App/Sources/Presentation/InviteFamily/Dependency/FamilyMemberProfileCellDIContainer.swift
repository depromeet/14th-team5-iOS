//
//  FamilyMemberProfileCellDIContainer.swift
//  App
//
//  Created by 김건우 on 12/28/23.
//

import Foundation

import Domain

public final class FamilyMemberProfileCellDIContainer {
    
    let memberResponse: FamilyMemberProfileResponse
    
    public init(member: FamilyMemberProfileResponse) {
        self.memberResponse = member
    }
    
    public func makeReactor() -> FamilyMemberProfileCellReactor {
        return FamilyMemberProfileCellReactor(memberResponse)
    }
}
