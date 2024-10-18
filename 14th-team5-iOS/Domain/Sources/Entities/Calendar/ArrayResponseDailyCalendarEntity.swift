//
//  ArrayResponseDailyCalendarEntity.swift
//  Domain
//
//  Created by 김건우 on 5/3/24.
//

import Foundation

public struct ArrayResponseDailyCalendarEntity {
    public var results: [DailyCalendarEntity]
    
    public init(results: [DailyCalendarEntity]) {
        self.results = results
    }
}

public struct DailyCalendarEntity {
    public var date: Date
    public var type: PostType
    public var postId: String
    public var postImageUrl: String
    public var postContent: String?
    public var missionContent: String?
    public var authorId: String
    public var commentCount: Int
    public var emojiCount: Int
    public var allFamilyMembersUploaded: Bool
    public var createdAt: Date
    
    public init(
        date: Date,
        type: PostType,
        postId: String,
        postImageUrl: String,
        postContent: String?,
        missionContent: String?,
        authorId: String,
        commentCount: Int,
        emojiCount: Int,
        allFamilyMembersUploaded: Bool,
        createdAt: Date
    ) {
        self.date = date
        self.type = type
        self.postId = postId
        self.postImageUrl = postImageUrl
        self.postContent = postContent
        self.missionContent = missionContent
        self.authorId = authorId
        self.commentCount = commentCount
        self.emojiCount = emojiCount
        self.allFamilyMembersUploaded = allFamilyMembersUploaded
        self.createdAt = createdAt
    }
}

extension DailyCalendarEntity: Equatable { }
