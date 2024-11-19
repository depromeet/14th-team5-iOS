//
//  PostDetailEntity.swift
//  Domain
//
//  Created by 김도현 on 11/19/24.
//

import Foundation



public struct PostDetailEntity {
    public let postId: String
    public let authorId: String
    public let type: PostType
    public let missionId: String?
    public let commentCount: Int
    public let emojiCount: Int
    public let imageUrl: String
    public let content: String
    public let createdAt: String
    
    
    public init(
        postId: String,
        authorId: String,
        type: PostType,
        missionId: String?,
        commentCount: Int,
        emojiCount: Int,
        imageUrl: String,
        content: String,
        createdAt: String
    ) {
        self.postId = postId
        self.authorId = authorId
        self.type = type
        self.missionId = missionId
        self.commentCount = commentCount
        self.emojiCount = emojiCount
        self.imageUrl = imageUrl
        self.content = content
        self.createdAt = createdAt
    }
}
