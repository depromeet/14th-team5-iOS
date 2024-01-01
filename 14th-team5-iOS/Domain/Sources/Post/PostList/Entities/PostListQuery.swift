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
    public let date: String
    public let memberId: String
    /// DESC | ASC
    public let sort: String
    
    public init(page: Int, size: Int, date: String, memberId: String, sort: PostListQuery.Sort) {
        self.page = page
        self.size = size
        self.date = date
        self.memberId = memberId
        self.sort = sort.rawValue
    }
}

extension PostListQuery {
    public enum Sort: String {
        case asc = "ASC"
        case desc = "DESC"
    }
}
