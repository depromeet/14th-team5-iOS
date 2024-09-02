//
//  DeleteCommentUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol DeleteCommentUseCaseProtocol {
    func execute(postId: String, commentId: String) -> Observable<PostCommentDeleteEntity?>
}

public final class DeleteCommentUseCase: DeleteCommentUseCaseProtocol {
    
    // MARK: - Repositories
    private let commentRepository: CommentRepositoryProtocol
    
    // MARK: - Intializer
    public init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
    }
    
    // MARK: - Execute
    public func execute(
        postId: String,
        commentId: String
    ) -> Observable<PostCommentDeleteEntity?> {
        return commentRepository.deletePostComment(postId: postId, commentId: commentId)
    }
    
}

