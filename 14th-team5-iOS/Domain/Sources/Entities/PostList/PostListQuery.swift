//
//  PostListQuery.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Core
import Foundation

public enum Sort: String {
    case asc = "ASC"
    case desc = "DESC"
}

public struct PostListQuery {
    public var page: Int
    public let size: Int
    public let date: String
    public var memberId: String?
    public var type: BibbiFeedType
    public let sort: String
    
    public init(
        page: Int = 1,
        size: Int = 256,
        date: String,
        memberId: String? = nil,
        type: BibbiFeedType,
        sort: Sort = .desc
    ) {
        self.page = page
        self.size = size
        self.date = date
        self.memberId = memberId
        self.type = type
        self.sort = sort.rawValue
    }
}
