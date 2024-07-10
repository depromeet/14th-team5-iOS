//
//  CommentAPIWorker.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Core
import Domain
import Foundation

import RxSwift

typealias CommentAPIWorker = CommentAPIs.Worker
extension CommentAPIs {
    final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "PostCommentAPIWorker", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "PostCommentAPIWorker"
        }
    }
}


// MARK: - Extensions

extension CommentAPIWorker {    
    
    
    // MARK: - Fetch Comment
    
    public func fetchComment(
        postId: String,
        query: PostCommentPaginationQuery
    ) -> Single<PaginationResponsePostCommentResponseDTO?> {
        let page = query.page
        let size = query.size
        let sort = query.sort.rawValue
        let spec = CommentAPIs.fetchPostComment(postId, page, size, sort).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .map(PaginationResponsePostCommentResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    // MARK: - Create Comment
    
    public func createComment(
        postId: String,
        body: CreatePostCommentReqeustDTO
    ) -> Single<PostCommentResponseDTO?> {
        let spec = CommentAPIs.createPostComment(postId).spec
        let headers = {
            let accessToken = App.Repository.token.accessToken.value?.accessToken
            var apiHeaders: [APIHeader] = [
                BibbiAPI.Header.xAppKey,
                BibbiAPI.Header.xAuthToken(accessToken!)
            ]
            return apiHeaders
        }() // TODO: - APIWorker 리팩토링되는 대로 코드 삭제하기
        return request(spec: spec, headers: headers, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .map(PostCommentResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    // MARK: - Update Comment
    
    public func updateComment(
        postId: String,
        commentId: String,
        body: UpdatePostCommentReqeustDTO
    ) -> Single<PostCommentResponseDTO?> {
        let spec = CommentAPIs.updatePostComment(postId, commentId).spec
        
        return request(spec: spec, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .map(PostCommentResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    // MARK: - Delete Comment
    
    public func deleteComment(
        postId: String,
        commentId: String
    ) -> Single<PostCommentDeleteResponseDTO?> {
        let spec = CommentAPIs.deletePostComment(postId, commentId).spec
        
        return request(spec: spec)
            .subscribe(on: Self.queue)
            .map(PostCommentDeleteResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
}
