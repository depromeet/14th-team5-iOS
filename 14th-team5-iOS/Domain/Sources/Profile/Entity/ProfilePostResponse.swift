//
//  ProfilePostResponse.swift
//  Domain
//
//  Created by Kim dohyun on 12/26/23.
//

import Foundation


public struct ProfilePostResponse {
    
    public var currentPage: Int
    public var totalPage: Int
    public var itemPerPage: Int
    public var hasNext: Bool
    public var results: [ProfilePostResultResponse]
    
}

public struct ProfilePostResultResponse {
    public var postId: String
    public var authorId: String
    public var commentCount: String
    public var emojiCount: String
    public var imageUrl: URL
    public var content: String
    public var createdAt: String
}
