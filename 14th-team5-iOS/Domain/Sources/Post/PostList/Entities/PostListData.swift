//
//  DailyPostData.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

public struct PostListData: Equatable {
    public init() {
        
    }
}

public struct PostListPage: Equatable {
    let currentPage: Int
    let totalPages: Int
    let postLists: [PostListData]
    
    public init(currentPage: Int, totalPages: Int, postLists: [PostListData]) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.postLists = postLists
    }
}
