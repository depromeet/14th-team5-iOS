//
//  DailyPostData.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

public struct PostEntity: Equatable, Hashable {
    public let postId: String
    public let author: ProfileData?
    public var commentCount: Int
    public let missionId: String?
    public let missionType: String?
    public let emojiCount: Int
    public let imageURL: String
    public let content: String?
    public let time: String
    
    public init(postId: String, missionId: String? = nil, missionType: String? = nil,  author: ProfileData?, commentCount: Int, emojiCount: Int, imageURL: String, content: String?, time: String) {
        self.postId = postId
        self.missionId = missionId
        self.missionType = missionType
        self.author = author
        self.commentCount = commentCount
        self.emojiCount = emojiCount
        self.imageURL = imageURL
        self.content = content
        self.time = time
    }
}

public struct PostListPage: Equatable {
    public let isLast: Bool
    public let postLists: [PostEntity]
    
    public init(isLast: Bool, postLists: [PostEntity]) {
        self.isLast = isLast
        self.postLists = postLists
    }
}
