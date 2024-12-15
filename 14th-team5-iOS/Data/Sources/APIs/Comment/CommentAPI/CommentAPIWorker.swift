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

extension CommentAPIWorker {    
    
    /// 게시물에 등록 된 댓글을 페이지네이션으로 조회하는 Method입니다.
    /// HTTP Method: GET
    /// - Parameters: postId: String
    /// - Returns: GetPostCommentResponseDTO
    func fetchComment(
        postId: String,
        query: PostCommentPaginationQuery
    ) -> Observable<GetPostCommentResponseDTO> {
        let page = query.page
        let size = query.size
        let sort = query.sort.rawValue
        let spec = CommentAPIs.fetchPostComment(postId: postId, page: page, size: size, sort: sort).spec
        
        return request(spec)
    }
    
    
    /// 게시물에 댓글을 등록하는 Method입니다.
    /// HTTP Method: POST
    /// - Parameters: postId: String
    /// - Returns: PostCommentResponseDTO
    func createComment(
        postId: String,
        body: CreatePostCommentReqeustDTO
    ) -> Observable<PostCommentResponseDTO> {
        let spec = CommentAPIs.createPostComment(postId: postId, body: body).spec
       
        return request(spec)
    }
    
    
    /// 게시물에 등록된 댓글을 수정하는 Method입니다.
    /// HTTP Method: PUT
    /// - Parameters: postId: String, commentId: String
    /// - Returns: PostCommentResponseDTO
    func updateComment(
        postId: String,
        commentId: String,
        body: UpdatePostCommentReqeustDTO
    ) -> Observable<PostCommentResponseDTO> {
        let spec = CommentAPIs.updatePostComment(postId: postId, commentId: commentId).spec
        
        return request(spec)
    }
    
    
    /// 게시물에 등록된 댓글을 삭제하는 Method입니다.
    /// HTTP Method: Delete
    /// - Parameters: postId: String, commentId: String
    /// - Returns: DeletePostCommentResponseDTO
    func deleteComment(
        postId: String,
        commentId: String
    ) -> Observable<DeletePostCommentResponseDTO> {
        let spec = CommentAPIs.deletePostComment(postId: postId, commentId: commentId).spec
        
        return request(spec)
    }
    
}
