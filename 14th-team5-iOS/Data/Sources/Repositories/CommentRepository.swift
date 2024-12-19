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
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let commentApiWorker: CommentAPIWorker = CommentAPIWorker()
    
    public init() { }
}

extension CommentRepository {
    
    // MARK: - Fetch Comment
    
    public func fetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentEntity> {
        return commentApiWorker.fetchComment(postId: postId, query: query)
            .map { $0.toDomain() }
    }
    
    
    // MARK: - Create Comment
    
    public func createPostComment(postId: String, body: CreatePostCommentRequest) -> Observable<PostCommentEntity?> {
        let body = CreatePostCommentReqeustDTO(content: body.content)
        return commentApiWorker.createComment(postId: postId, body: body)
            .map { $0.toDomain() }
    }
    
    
    // MARK: - Update Comment
    
    public func updatePostComment(postId: String, commentId: String, body: UpdatePostCommentRequest) -> Observable<PostCommentEntity?> {
        let body = UpdatePostCommentReqeustDTO(content: body.content)
        return commentApiWorker.updateComment(postId: postId, commentId: commentId, body: body)
            .map { $0.toDomain() }
    }
    
    
    // MARK: - Delete Comment
    
    public func deletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteEntity?> {
        return commentApiWorker.deleteComment(postId: postId, commentId: commentId)
            .map { $0.toDomain() }
    }
}
