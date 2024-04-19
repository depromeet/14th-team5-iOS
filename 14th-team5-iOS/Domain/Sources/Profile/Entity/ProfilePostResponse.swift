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
    
    public init(currentPage: Int, totalPage: Int, itemPerPage: Int, hasNext: Bool, results: [ProfilePostResultResponse]) {
        self.currentPage = currentPage
        self.totalPage = totalPage
        self.itemPerPage = itemPerPage
        self.hasNext = hasNext
        self.results = results
    }
    
}

public struct ProfilePostResultResponse {
    public var postId: String
    public var authorId: String
    public var commentCount: String
    public var emojiCount: String
    public var imageUrl: URL
    public var content: String
    public var createdAt: String
    public var missionId: String
    public var missionType: String
    
    public init(postId: String, authorId: String, commentCount: String, emojiCount: String, imageUrl: URL, content: String, createdAt: String, missionId: String, missionType: String) {
        self.postId = postId
        self.authorId = authorId
        self.commentCount = commentCount
        self.emojiCount = emojiCount
        self.imageUrl = imageUrl
        self.content = content
        self.createdAt = createdAt
        self.missionId = missionId
        self.missionType = missionType
    }
}
