//
//  PostCommentRepository.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Domain
import Foundation

import RxSwift

public final class CommentRepository: CommentRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let commentApiWorker: CommentAPIWorker = CommentAPIWorker()
    
    public init() { }
}

extension CommentRepository {
    public func fetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentResponse?> {
        return commentApiWorker.fetchComment(postId: postId, query: query)
            .asObservable()
    }
    
    public func createPostComment(postId: String, body: CreatePostCommentRequest) -> Observable<PostCommentResponse?> {
        let body = CreatePostCommentReqeustDTO(content: body.content)
        return commentApiWorker.createComment(postId: postId, body: body)
            .asObservable()
    }
    
    public func updatePostComment(postId: String, commentId: String, body: UpdatePostCommentRequest) -> Observable<PostCommentResponse?> {
        let body = UpdatePostCommentReqeustDTO(content: body.content)
        return commentApiWorker.updateComment(postId: postId, commentId: commentId, body: body)
            .asObservable()
    }
    
    public func deletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteResponse?> {
        return commentApiWorker.deleteComment(postId: postId, commentId: commentId)
            .asObservable()
    }
}
