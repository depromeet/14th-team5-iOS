//
//  MemberProfileCellType.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import Foundation

// MARK: - Typealias

public typealias FamilyMemberCellKind = FamilyMemberCell.Kind


// MARK: - Extensions

public extension FamilyMemberCell {
    
    enum Kind {
        case emoji
        case management
    }
    
}
