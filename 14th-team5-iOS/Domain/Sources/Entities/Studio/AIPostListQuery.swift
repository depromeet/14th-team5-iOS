//
//  AIPostListQuery.swift
//  Domain
//
//  Created by 마경미 on 20.12.25.
//

import Core
import Foundation

public enum StudioType: String {
    case chuseok_2025 = "CHUSEOK_2025"
    case christmas_2025 = "CHRISTMAS_2025"
}

public struct AIPostListQuery {
    public var page: Int
    public let size: Int
    public let date: String
    public var memberId: String?
    public var type: StudioType
    public let sort: String
    
    public init(
        page: Int = 1,
        size: Int = 256,
        date: String,
        memberId: String? = nil,
        type: StudioType,
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
