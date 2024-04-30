//
//  PostListQuery.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

public enum Sort: String {
    case asc = "ASC"
    case desc = "DESC"
}

public enum PostType: String {
    case survival = "SURVIVAL"
    case mission = "MISSION"
    
    public func getIndex() -> Int {
        switch self {
        case .survival:
            return 0
        case .mission:
            return 1
        }
    }
    
    public static func getPostType(index: Int) -> PostType {
        switch index {
        case 0:
            return .survival
        case 1:
            return .mission
        default:
            fatalError("index Out of range")
        }
    }
}

public struct PostListQuery {
    public let page: Int
    public let size: Int
    public let date: String
    public let memberId: String
    public let type: PostType
    public let sort: String
    
    public init(
        page: Int = 1,
        size: Int = 256,
        date: String,
        memberId: String = "",
        type: PostType = .survival,
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
