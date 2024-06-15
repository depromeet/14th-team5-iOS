//
//  FamilyPaginationQuery.swift
//  Domain
//
//  Created by 김건우 on 1/25/24.
//

import Foundation

public struct FamilyPaginationQuery {
    public var page: Int
    public var size: Int
    
    public init(page: Int = 1, size: Int = 256) {
        self.page = page
        self.size = size
    }
}
