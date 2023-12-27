//
//  PostListQuery.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

public struct PostListQuery {
    public let page: Int
    public let size: Int
    public let data: String
    public let memberId: String
    /// DESC | ASC
    public let sort: String
    
    public init(page: Int, size: Int, data: String, memberId: String, sort: String) {
        self.page = page
        self.size = size
        self.data = data
        self.memberId = memberId
        self.sort = sort
    }
}
