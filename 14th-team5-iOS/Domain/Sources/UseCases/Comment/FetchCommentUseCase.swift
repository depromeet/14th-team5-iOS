//
//  FetchCommentUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol FetchCommentUseCaseProtocol {
    func execute(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentEntity>
}

public final class FetchCommentUseCase: FetchCommentUseCaseProtocol {
    
    // MARK: - Repositories
    private let commentRepository: CommentRepositoryProtocol
    
    // MARK: - Intializer
    public init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
    }
    
    // MARK: - Execute
    public func execute(
        postId: String,
        query: PostCommentPaginationQuery
    ) -> Observable<PaginationResponsePostCommentEntity> {
        return commentRepository.fetchPostComment(postId: postId, query: query)
    }
    
}
