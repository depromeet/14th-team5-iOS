//
//  PostCommentRepositoryProtocol.swift
//  Domain
//
//  Created by 김건우 on 1/17/24.
//

import Foundation

import RxSwift

public protocol CommentRepositoryProtocol {
    func fetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentEntity>
    func createPostComment(postId: String, body: CreatePostCommentRequest) -> Observable<PostCommentEntity?>
    func updatePostComment(postId: String, commentId: String, body: UpdatePostCommentRequest) -> Observable<PostCommentEntity?>
    func deletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteEntity?>
}
