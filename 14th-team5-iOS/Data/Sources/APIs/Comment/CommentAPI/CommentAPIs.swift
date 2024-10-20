//
//  CommentAPIs.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Core
import Foundation

enum CommentAPIs: BBAPI {
    case fetchPostComment(postId: String, page: Int, size: Int, sort: String)
    case createPostComment(postId: String, body: CreatePostCommentReqeustDTO)
    case updatePostComment(postId: String, commentId: String)
    case deletePostComment(postId: String, commentId: String)
    
    var spec: Spec {
        switch self {
        case let .fetchPostComment(postId, page, size, sort):
            return Spec(
                method: .get,
                path: "/posts/\(postId)/comments",
                queryParameters: [
                    .page: "\(page)",
                    .size: "\(size)",
                    .sort: "\(sort)"
                ]
            )
            
        case let .createPostComment(postId, body):
            return Spec(
                method: .post,
                path: "/posts/\(postId)/comments",
                bodyParameters: ["content": "\(body.content)"]
            )
            
        case let .updatePostComment(postId, commentId):
            return Spec(
                method: .put,
                path: "/posts/\(postId)/comments/\(commentId)"
            )
            
        case let .deletePostComment(postId, commentId):
            return Spec(
                method: .delete,
                path: "/posts/\(postId)/comments/\(commentId)"
            )
        }
    }
}
