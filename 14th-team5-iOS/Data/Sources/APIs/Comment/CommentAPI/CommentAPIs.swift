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
    
    var spec: BBAPISpec {
        switch self {
        case let .fetchPostComment(postId, page, size, sort):
            return BBAPISpec(
                method: .get,
                path: "/posts/\(postId)/comments",
                queryParameters: [
                    .page: "\(page)",
                    .size: "\(size)",
                    .sort: "\(sort)"
                ]
            )
            
        case let .createPostComment(postId, body):
            return BBAPISpec(
                method: .post,
                path: "/posts/\(postId)/comments",
                bodyParametersEncodable: body
            )
            
        case let .updatePostComment(postId, commentId):
            return BBAPISpec(
                method: .put,
                path: "/posts/\(postId)/comments/\(commentId)"
            )
            
        case let .deletePostComment(postId, commentId):
            return BBAPISpec(
                method: .delete,
                path: "/posts/\(postId)/comments/\(commentId)"
            )
        }
    }
}
