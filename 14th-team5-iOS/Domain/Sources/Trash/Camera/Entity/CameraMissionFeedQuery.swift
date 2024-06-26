//
//  CameraMissionFeedQuery.swift
//  Domain
//
//  Created by Kim dohyun on 5/2/24.
//

import Foundation


public struct CameraMissionFeedQuery {
    public var type: String
    public var isUploded: Bool
    
    
    public init(type: String, isUploded: Bool) {
        self.type = type
        self.isUploded = isUploded
    }
}
