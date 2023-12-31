//
//  DailyPostData.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

public struct PostListData: Equatable {
    public let postId: String
    public let author: String
    public let emojiCount: Int
    public let imageURL: String
    public let content: String
    public let time: String
    
    public init(postId: String, author: String, emojiCount: Int, imageURL: String, content: String, time: String) {
        self.postId = postId
        self.author = author
        self.emojiCount = emojiCount
        self.imageURL = imageURL
        self.content = content
        self.time = time
    }
}

public struct PostListPage: Equatable {
    let currentPage: Int
    let totalPages: Int
    public let postLists: [PostListData]
    
    public init(currentPage: Int, totalPages: Int, postLists: [PostListData]) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.postLists = postLists
    }
    
    public func checkAuthor(authorId: String) -> Bool {
        for post in postLists {
            if post.author == authorId { return true }
        }
        return false
    }
}
