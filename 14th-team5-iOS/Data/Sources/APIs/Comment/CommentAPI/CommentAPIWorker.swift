//
//  CommentAPIWorker.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Core
import Domain
import Foundation

import RxSwift

typealias CommentAPIWorker = CommentAPIs.Worker
extension CommentAPIs {
    final class Worker: BBAPIWorker { }
}


// MARK: - Extensions

extension CommentAPIWorker {    
    
    
    // MARK: - Fetch Comment
    
    public func fetchComment(
        postId: String,
        query: PostCommentPaginationQuery
    ) -> Observable<PaginationResponsePostCommentResponseDTO> {
        let page = query.page
        let size = query.size
        let sort = query.sort.rawValue
        let spec = CommentAPIs.fetchPostComment(postId: postId, page: page, size: size, sort: sort).spec
        
        return request(spec, of: PaginationResponsePostCommentResponseDTO.self)
    }
    
    
    // MARK: - Create Comment
    
    public func createComment(
        postId: String,
        body: CreatePostCommentReqeustDTO
    ) -> Observable<PostCommentResponseDTO> {
        let spec = CommentAPIs.createPostComment(postId: postId, body: body).spec
       
        return request(spec, of: PostCommentResponseDTO.self)
    }
    
    
    // MARK: - Update Comment
    
    public func updateComment(
        postId: String,
        commentId: String,
        body: UpdatePostCommentReqeustDTO
    ) -> Observable<PostCommentResponseDTO> {
        let spec = CommentAPIs.updatePostComment(postId: postId, commentId: commentId).spec
        
        return request(spec, of: PostCommentResponseDTO.self)
    }
    
    
    // MARK: - Delete Comment
    
    public func deleteComment(
        postId: String,
        commentId: String
    ) -> Observable<PostCommentDeleteResponseDTO> {
        let spec = CommentAPIs.deletePostComment(postId: postId, commentId: commentId).spec
        
        return request(spec, of: PostCommentDeleteResponseDTO.self)
    }
    
}
