//
//  CreateCommentUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol CreateCommentUseCaseProtocol {
    func execute(postId: String, body: CreatePostCommentRequest) -> Observable<PostCommentEntity?>
}

public final class CreateCommentUseCase: CreateCommentUseCaseProtocol {
    
    // MARK: - Repositories
    private let commentRepository: CommentRepositoryProtocol
    
    // MARK: - Intializer
    public init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
    }
    
    // MARK: - Execute
    public func execute(
        postId: String,
        body: CreatePostCommentRequest
    ) -> Observable<PostCommentEntity?> {
        return commentRepository.createPostComment(postId: postId, body: body)
    }
    
}
