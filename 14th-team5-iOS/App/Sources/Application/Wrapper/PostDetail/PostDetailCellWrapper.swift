//
//  PostDetailCellWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Foundation

import Domain

final class PostDetailCellWrapper {
    private let type: PostDetailViewReactor.CellType = .home
    private let post: PostEntity
    
    init(post: PostEntity) {
        self.post = post
    }

    func makeReactor() -> PostDetailViewReactor {
        return PostDetailViewReactor(
            initialState: .init(type: type, post: post)
        )
    }
}
