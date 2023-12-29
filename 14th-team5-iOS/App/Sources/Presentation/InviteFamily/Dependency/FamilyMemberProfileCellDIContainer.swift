//
//  FamilyMemberProfileCellDIContainer.swift
//  App
//
//  Created by 김건우 on 12/28/23.
//

import Foundation

import Domain

public final class FamilyMemberProfileCellDIContainer {
    public func makeReactor(
        _ memberResponse: FamilyMemberProfileResponse
    ) -> FamilyMemberProfileCellReactor {
        return FamilyMemberProfileCellReactor(memberResponse)
    }
}
