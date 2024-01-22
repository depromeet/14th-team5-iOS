//
//  PostCommentRepository.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Domain
import Foundation

import RxSwift

public final class PostCommentRepository: PostCommentRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let postCommentApiWorker: PostCommentAPIWorker = PostCommentAPIWorker()
    
    public init() { }
}

extension PostCommentRepository {
    public func fetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Observable<PaginationResponsePostCommentResponse?> {
        return postCommentApiWorker.fetchPostComment(postId: postId, query: query)
            .asObservable()
    }
    
    public func createPostComment(postId: String, body: CreatePostCommentBody) -> Observable<PostCommentResponse?> {
        let body = CreatePostCommentReqeustDTO(content: body.content)
        return postCommentApiWorker.createPostComment(postId: postId, body: body)
            .asObservable()
    }
    
    public func updatePostComment(postId: String, commentId: String, body: UpdatePostCommentBody) -> Observable<PostCommentResponse?> {
        let body = UpdatePostCommentReqeustDTO(content: body.content)
        return postCommentApiWorker.updatePostComment(postId: postId, commentId: commentId, body: body)
            .asObservable()
    }
    
    public func deletePostComment(postId: String, commentId: String) -> Observable<PostCommentDeleteResponse?> {
        return postCommentApiWorker.deletePostComment(postId: postId, commentId: commentId)
            .asObservable()
    }
    
    public func fetchUserName(memberId: String) -> String {
        return FamilyUserDefaults.loadMemberFromUserDefaults(memberId: memberId)?.name ?? .unknown
    }
    
    public func fetchProfileImageUrlString(memberId: String) -> String {
        return FamilyUserDefaults.loadMemberFromUserDefaults(memberId: memberId)?.profileImageURL ?? .unknown
    }
}
