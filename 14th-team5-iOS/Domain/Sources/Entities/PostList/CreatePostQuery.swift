//
//  CreatePostQuery.swift
//  Domain
//
//  Created by 김도현 on 11/19/24.
//

import Foundation


public struct CreatePostQuery {
    public let type: String
    
    public init(type: String) {
        self.type = type
    }
}
