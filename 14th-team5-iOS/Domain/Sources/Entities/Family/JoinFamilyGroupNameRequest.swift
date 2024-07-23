//
//  JoinFamilyGroupNameRequest.swift
//  Domain
//
//  Created by Kim dohyun on 7/23/24.
//

import Foundation


public struct JoinFamilyGroupNameRequest {
    public let familyName: String
    
    public init(familyName: String) {
        self.familyName = familyName
    }
}
