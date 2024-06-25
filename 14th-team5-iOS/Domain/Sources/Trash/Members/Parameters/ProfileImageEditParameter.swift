//
//  ProfileImageEditParameter.swift
//  Domain
//
//  Created by Kim dohyun on 12/27/23.
//

import Foundation


public struct ProfileImageEditParameter: Encodable {
    public var profileImageUrl: String
    
    public init(profileImageUrl: String) {
        self.profileImageUrl = profileImageUrl
    }
    
}
