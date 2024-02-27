//
//  FCMToken.swift
//  Domain
//
//  Created by 마경미 on 20.02.24.
//

import Foundation

public struct FCMToken: Codable, Equatable {
    public let fcmToken: String
    
    public init(fcmToken: String) {
        self.fcmToken = fcmToken
    }
}
