//
//  SearchFamilyQuery.swift
//  Domain
//
//  Created by 마경미 on 24.12.23.
//

import Foundation

@available(*, deprecated, renamed: "FamilyPaginationQuery")
public struct SearchFamilyQuery {
    public let page: Int
    public let size: Int
    
    public init(page: Int, size: Int) {
        self.page = page
        self.size = size
    }
}
