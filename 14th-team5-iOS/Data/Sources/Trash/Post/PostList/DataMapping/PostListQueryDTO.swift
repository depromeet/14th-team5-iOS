//
//  PostListQueryDTO.swift
//  Data
//
//  Created by 김도현 on 11/20/24.
//

import Foundation

public struct PostListQueryDTO: Encodable {
    public let page: Int
    public let size: Int
    public let date: String
    public let memberId: String?
    public let type: String
    public let sort: String
    
    
    public init(
        page: Int,
        size: Int,
        date: String,
        memberId: String? = nil,
        type: String,
        sort: String
    ) {
        self.page = page
        self.size = size
        self.date = date
        self.memberId = memberId
        self.type = type
        self.sort = sort
    }
    
}
