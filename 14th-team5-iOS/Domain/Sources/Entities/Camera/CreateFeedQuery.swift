//
//  CreateFeedQuery.swift
//  Domain
//
//  Created by 김도현 on 11/18/24.
//

import Foundation


public struct CreateFeedQuery {
    public let type: String
    
    public init(type: String) {
        self.type = type
    }
}
