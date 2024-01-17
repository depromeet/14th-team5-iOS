//
//  PostCommentAPIs.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Foundation

import Domain

enum PostCommentAPIs: API {
    case getPostComment(String, Int, Int, String)
    case addPostComment(String)
    case updatePostComment(String, String)
    case deletePostComment(String, String)
    
    var spec: APISpec {
        switch self {
        case let .getPostComment(postId, page, size, sort):
            return APISpec(method: .get, url: "\(BibbiAPI.hostApi)/posts/\(postId)/comments?page=\(page)&size=\(size)&sort=\(sort)")
        case let .addPostComment(postId):
            return APISpec(method: .post, url: "\(BibbiAPI.hostApi)/posts/\(postId)/comments")
        case let .updatePostComment(postId, commentId):
            return APISpec(method: .put, url: "\(BibbiAPI.hostApi)/posts/\(postId)/comments/\(commentId)")
        case let .deletePostComment(postId, commentId):
            return APISpec(method: .delete, url: "\(BibbiAPI.hostApi)/posts/\(postId)/comments/\(commentId)")
        }
    }
}
