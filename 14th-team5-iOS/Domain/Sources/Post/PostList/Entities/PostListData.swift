//
//  DailyPostData.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

public struct PostListData: Equatable {
    public let postId: String
    public let author: ProfileData?
    public let emojiCount: Int
    public let imageURL: String
    public let content: String
    public let time: String
    
    public init(postId: String, author: ProfileData?, emojiCount: Int, imageURL: String, content: String, time: String) {
        self.postId = postId
        self.author = author
        self.emojiCount = emojiCount
        self.imageURL = imageURL
        self.content = content
        self.time = time
    }
}

public struct PostListPage: Equatable {
    public let isLast: Bool
    public let postLists: [PostListData]
    public let allFamilyMembersUploaded: Bool
    public let selfUploaded: Bool
    
    public init(isLast: Bool, postLists: [PostListData], allFamilyMembersUploaded: Bool, selfUploaded: Bool) {
        self.isLast = isLast
        self.postLists = postLists
        self.allFamilyMembersUploaded = allFamilyMembersUploaded
        self.selfUploaded = selfUploaded
    }
}
