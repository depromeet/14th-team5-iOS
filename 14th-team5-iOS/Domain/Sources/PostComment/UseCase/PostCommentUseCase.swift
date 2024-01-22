//
//  PostCommentUseCase.swift
//  Domain
//
//  Created by 김건우 on 1/22/24.
//

import Foundation

import RxSwift

public protocol PostCommentUseCaseProtocol {
    func executeFetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentResponse?>
    func executeCreatePostComment(postId: String, body: CreatePostCommentBody) -> Observable<PostCommentResponse?>
    func executeDeletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteResponse?>
    func executeFetchUserName(memberId: String) -> String
    func executeFetchProfileImageUrlString(memberId: String) -> String
}

public final class PostCommentUseCase: PostCommentUseCaseProtocol {
    private let postCommentRepository: PostCommentRepositoryProtocol
    
    public init(postCommentRepository: PostCommentRepositoryProtocol) {
        self.postCommentRepository = postCommentRepository
    }
    
    public func executeFetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentResponse?> {
        return postCommentRepository.fetchPostComment(postId: postId, query: query)
    }
    
    public func executeCreatePostComment(postId: String, body: CreatePostCommentBody) -> Observable<PostCommentResponse?> {
        return postCommentRepository.createPostComment(postId: postId, body: body)
    }
    
    public func executeDeletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteResponse?> {
        return postCommentRepository.deletePostComment(postId: postId, commentId: commentId)
    }
    
    public func executeFetchUserName(memberId: String) -> String {
        return postCommentRepository.fetchUserName(memberId: memberId)
    }
    
    public func executeFetchProfileImageUrlString(memberId: String) -> String {
        return postCommentRepository.fetchProfileImageUrlString(memberId: memberId)
    }
}
