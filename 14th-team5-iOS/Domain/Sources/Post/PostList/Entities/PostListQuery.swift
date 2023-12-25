//
//  PostListQuery.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

public struct PostListQuery {
    let page: Int
    let size: Int
    let data: String
    let memberId: String
    /// DESC | ASC
    let sort: String
    
    public init(page: Int, size: Int, data: String, memberId: String, sort: String) {
        self.page = page
        self.size = size
        self.data = data
        self.memberId = memberId
        self.sort = sort
    }
}
