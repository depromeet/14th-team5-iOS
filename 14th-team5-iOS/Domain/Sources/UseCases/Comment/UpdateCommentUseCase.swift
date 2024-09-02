//
//  UpdateCommentUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol UpdateCommentUseCaseProtocol {
    func execute(postId: String, commentId: String, body: UpdatePostCommentRequest) -> Observable<PostCommentEntity?>
}

public final class UpdateCommentUseCase: UpdateCommentUseCaseProtocol {
    
    // MARK: - Repositories
    private let commentRepository: CommentRepositoryProtocol
    
    // MARK: - Intializer
    public init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
    }
    
    // MARK: - Execute
    public func execute(
        postId: String,
        commentId: String,
        body: UpdatePostCommentRequest
    ) -> Observable<PostCommentEntity?> {
        return commentRepository.updatePostComment(postId: postId, commentId: commentId, body: body)
    }
    
}

