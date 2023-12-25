//
//  DailyPostData.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

struct PostListData: Equatable {
    
}

struct PostListPage: Equatable {
    let currentPage: Int
    let totalPages: Int
    let postLists: [PostListData]
    
    init(currentPage: Int, totalPages: Int, postLists: [PostListData]) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.postLists = postLists
    }
}
