//
//  UpdateFamilyNameRequest.swift
//  Domain
//
//  Created by 김건우 on 8/11/24.
//

import Foundation

public struct UpdateFamilyNameRequest {
    public let familyName: String?
    
    public init(familyName: String?) {
        self.familyName = familyName
    }
}
