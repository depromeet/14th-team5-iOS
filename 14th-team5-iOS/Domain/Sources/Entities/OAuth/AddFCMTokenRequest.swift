//
//  AddFCMTokenRequest.swift
//  Domain
//
//  Created by 김건우 on 6/6/24.
//

import Foundation

public struct AddFCMTokenRequest {
    public var fcmToken: String
    
    public init(fcmToken: String) {
        self.fcmToken = fcmToken
    }
}
