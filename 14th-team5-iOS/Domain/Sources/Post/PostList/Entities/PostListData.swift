//
//  DailyPostData.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

public struct PostListData: Equatable {
    public let author: String
    public let time: String
    public let imageURL: String
    
    public init(author: String, time: String, imageURL: String) {
        self.author = author
        self.time = time
        self.imageURL = imageURL
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
}
