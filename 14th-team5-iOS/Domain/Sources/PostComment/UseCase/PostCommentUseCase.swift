//
//  PostCommentUseCase.swift
//  Domain
//
//  Created by 김건우 on 1/22/24.
//

import Core
import Foundation

import RxSwift


public protocol PostCommentUseCaseProtocol {
    func executeFetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentResponse?>
    func executeCreatePostComment(postId: String, body: CreatePostCommentRequest) -> Observable<PostCommentResponse?>
    func executeDeletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteResponse?>
}

public final class PostCommentUseCase: PostCommentUseCaseProtocol {
    private let commentRepository: CommentRepositoryProtocol
    
    public init(
        commentRepository: CommentRepositoryProtocol
    ) {
        self.commentRepository = commentRepository
    }
    
    public func executeFetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentResponse?> {
        return commentRepository.fetchPostComment(postId: postId, query: query)
    }
    
    public func executeCreatePostComment(postId: String, body: CreatePostCommentRequest) -> Observable<PostCommentResponse?> {
        return commentRepository.createPostComment(postId: postId, body: body)
    }
    
    public func executeDeletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteResponse?> {
        return commentRepository.deletePostComment(postId: postId, commentId: commentId)
    }
}


public extension InjectIdentifier {
    
    static var commentUseCase: InjectIdentifier<PostCommentUseCaseProtocol> {
        .by(type: PostCommentUseCaseProtocol.self)
    }
    
}
