//
//  SearchFamilyQuery.swift
//  Domain
//
//  Created by 마경미 on 24.12.23.
//

import Foundation

public struct SearchFamilyQuery {
    let type: String
    let page: Int
    let size: Int
    
    public init(type: String, page: Int, size: Int) {
        self.type = type
        self.page = page
        self.size = size
    }
}
