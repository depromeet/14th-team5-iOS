//
//  PostCommentUseCase.swift
//  Domain
//
//  Created by 김건우 on 1/22/24.
//

import Core
import Foundation

import RxSwift

@available(*, deprecated)
public protocol PostCommentUseCaseProtocol {
    func executeFetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentEntity>
    func executeCreatePostComment(postId: String, body: CreatePostCommentRequest) -> Observable<PostCommentEntity?>
    func executeDeletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteEntity?>
}

@available(*, deprecated)
public final class PostCommentUseCase: PostCommentUseCaseProtocol {
    private let commentRepository: CommentRepositoryProtocol
    
    public init(
        commentRepository: CommentRepositoryProtocol
    ) {
        self.commentRepository = commentRepository
    }
    
    public func executeFetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentEntity> {
        return commentRepository.fetchPostComment(postId: postId, query: query)
    }
    
    public func executeCreatePostComment(postId: String, body: CreatePostCommentRequest) -> Observable<PostCommentEntity?> {
        return commentRepository.createPostComment(postId: postId, body: body)
    }
    
    public func executeDeletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteEntity?> {
        return commentRepository.deletePostComment(postId: postId, commentId: commentId)
    }
}


public extension InjectIdentifier {
    
    static var commentUseCase: InjectIdentifier<PostCommentUseCaseProtocol> {
        .by(type: PostCommentUseCaseProtocol.self)
    }
    
}
