//
//  NativeSocialLoginRequest.swift
//  Domain
//
//  Created by 김건우 on 6/6/24.
//

import Foundation

public struct NativeSocialLoginRequest {
    public var accessToken: String
    
    public init(accessToken: String) {
        self.accessToken = accessToken
    }
}
