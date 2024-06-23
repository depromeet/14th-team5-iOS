//
//  PaginationResponsePostCommentResponse.swift
//  Domain
//
//  Created by 김건우 on 1/17/24.
//

import Foundation

public struct PaginationResponsePostCommentEntity {
    public var currentPage: Int
    public var totalPage: Int
    public var itemPerPage: Int
    public var hasNext: Bool
    public var results: [PostCommentEntity]
    
    public init(
        currentPage: Int,
        totalPage: Int,
        itemPerPage: Int,
        hasNext: Bool,
        results: [PostCommentEntity]
    ) {
        self.currentPage = currentPage
        self.totalPage = totalPage
        self.itemPerPage = itemPerPage
        self.hasNext = hasNext
        self.results = results
    }
}

public struct PostCommentEntity {
    public var commentId: String
    public var postId: String
    public var memberId: String
    public var comment: String
    public var createdAt: Date
    
    public init(
        commentId: String,
        postId: String,
        memberId: String,
        comment: String,
        createdAt: Date
    ) {
        self.commentId = commentId
        self.postId = postId
        self.memberId = memberId
        self.comment = comment
        self.createdAt = createdAt
    }
}
