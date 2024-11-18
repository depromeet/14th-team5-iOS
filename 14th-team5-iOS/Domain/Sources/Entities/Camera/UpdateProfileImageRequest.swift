//
//  UpdateProfileImageRequest.swift
//  Domain
//
//  Created by 김도현 on 11/17/24.
//

import Foundation


public struct UpdateProfileImageRequest  {
    public let profileImageUrl: String
    
    public init(profileImageUrl: String) {
        self.profileImageUrl = profileImageUrl
    }
}
