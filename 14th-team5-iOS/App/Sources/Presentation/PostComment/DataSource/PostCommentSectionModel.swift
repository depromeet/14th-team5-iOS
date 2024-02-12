//
//  CommentAnimatableSectionModel.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Domain
import Foundation

import Differentiator

typealias PostCommentSectionModel = AnimatableSectionModel<String, CommentCellReactor>

extension PostCommentSectionModel {
    static func generateTestData() -> [PostCommentSectionModel] {
        let comment1: PostCommentResponse = PostCommentResponse(
            commentId: .none,
            postId: .none,
            memberId: "01HM0SHPB8663AATDN1YZCEB7E",
            comment: "Hello, Swift!",
            createdAt: Date().addingTimeInterval(-300)
        )
        
        let comment2: PostCommentResponse = PostCommentResponse(
            commentId: .none,
            postId: .none,
            memberId: "01HM4CZD12Y04FDEBG0WGST7KN",
            comment: "Hello, UIKit!",
            createdAt: Date().addingTimeInterval(-3_000)
        )
        
        let comment3: PostCommentResponse = PostCommentResponse(
            commentId: .none,
            postId: .none,
            memberId: "01HM4CZD12Y04FDEBG0WGST7KN",
            comment: "Hello, SwiftUI!",
            createdAt: Date().addingTimeInterval(-30_000)
        )
        
        return [
            PostCommentSectionModel(
                model: .none,
                items: [
//                    CommentCellReactor(comment1),
//                    CommentCellReactor(comment2),
//                    CommentCellReactor(comment3)
                ]
            )
        ]
    }
}
