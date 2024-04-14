//
//  CameraDisplayPostResponse.swift
//  Domain
//
//  Created by Kim dohyun on 12/22/23.
//

import Foundation


public struct CameraDisplayPostResponse {
    public var postId: String
    public var authorId: String
    public var commentCount: Int
    public var emojiCount: Int
    public var imageURL: String
    public var content: String
    public var createdAt: String
    
    public init(
        postId: String,
        authorId: String,
        commentCount: Int,
        emojiCount: Int,
        imageURL: String,
        content: String,
        createdAt: String
    ) {
        self.postId = postId
        self.authorId = authorId
        self.commentCount = commentCount
        self.emojiCount = emojiCount
        self.imageURL = imageURL
        self.content = content
        self.createdAt = createdAt
    }
    
}
