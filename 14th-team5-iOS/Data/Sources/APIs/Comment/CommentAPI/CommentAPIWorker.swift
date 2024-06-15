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
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Fetch PostComment Result: \(str)")
                }
            }
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
        
        return request(spec: spec, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Create PostComment Result: \(str)")
                }
            }
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
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Update PostComment Result: \(str)")
                }
            }
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
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Delete PostComment Result: \(str)")
                }
            }
            .map(PostCommentDeleteResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
}
