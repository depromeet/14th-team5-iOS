//
//  CommentAPIs.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Core
import Foundation

enum CommentAPIs: BBAPI {
    /// 게시물 댓글 조회
    case fetchPostComment(postId: String, page: Int, size: Int, sort: String)
    /// 게시물 댓글 추가
    case createPostComment(postId: String, body: CreatePostCommentReqeustDTO)
    /// 게시물 댓글 수정
    case updatePostComment(postId: String, commentId: String)
    /// 게시물 댓글 삭제
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
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
