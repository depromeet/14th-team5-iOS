//
//  PostCommentPaginationQuery.swift
//  Domain
//
//  Created by 김건우 on 1/17/24.
//

import Foundation

public struct PostCommentPaginationQuery {
    public var page: Int
    public var size: Int
    public var sort: PostCommentPaginationQuery.Sort
    
    public init(
        page: Int = 1,
        size: Int = 256,
        sort: PostCommentPaginationQuery.Sort = .asc
    ) {
        self.page = page
        self.size = size
        self.sort = sort
    }
}

extension PostCommentPaginationQuery {
    public enum Sort: String {
        case asc = "ASC"
        case desc = "DESC"
    }
}
