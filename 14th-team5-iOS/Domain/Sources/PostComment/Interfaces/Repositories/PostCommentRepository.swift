//
//  PostCommentRepositoryProtocol.swift
//  Domain
//
//  Created by 김건우 on 1/17/24.
//

import Foundation

import RxSwift

public protocol PostCommentRepositoryProtocol {
    var disposeBag: DisposeBag { get }
    
    func fetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentResponse?>
    func createPostComment(postId: String, body: CreatePostCommentBody) -> Observable<PostCommentResponse?>
    func updatePostComment(postId: String, commentId: String, body: UpdatePostCommentBody) -> Observable<PostCommentResponse?>
    func deletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteResponse?>
}
