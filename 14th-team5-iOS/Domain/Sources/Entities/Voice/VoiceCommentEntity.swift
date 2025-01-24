//
//  VoiceCommentEntity.swift
//  Domain
//
//  Created by 김도현 on 1/6/25.
//

import Foundation

public enum CommentType: String {
    case voice = "VOICE"
    case text = "TEXT"
}


public struct VoiceCommentEntity {
    public let commentId: String
    public let type: CommentType
    public let postId: String
    public let memberId: String
    public let comment: String
    public let createdAt: String
    
    
    public init(
        commentId: String,
        type: CommentType,
        postId: String,
        memberId: String,
        comment: String,
        createdAt: String
    ) {
        self.commentId = commentId
        self.type = type
        self.postId = postId
        self.memberId = memberId
        self.comment = comment
        self.createdAt = createdAt
    }
}
