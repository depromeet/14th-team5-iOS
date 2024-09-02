//
//  CameraPostEntity.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation

public struct CameraPostEntity {
    public let postId: String
    public let authorId: String
    public let commentCount: Int
    public let missionType: String
    public let missionId: String
    public let emojiCount: Int
    public let imageURL: String
    public let content: String
    public let createdAt: String
    
    public init(
        postId: String,
        authorId: String,
        commentCount: Int,
        missionType: String,
        missionId: String,
        emojiCount: Int,
        imageURL: String,
        content: String,
        createdAt: String
    ) {
        self.postId = postId
        self.authorId = authorId
        self.commentCount = commentCount
        self.missionType = missionType
        self.missionId = missionId
        self.emojiCount = emojiCount
        self.imageURL = imageURL
        self.content = content
        self.createdAt = createdAt
    }
}
