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
    
    public func fetchComment(postId: String, query: PostCommentPaginationQuery) -> Single<PaginationResponsePostCommentResponse?> {
        let page = query.page
        let size = query.size
        let sort = query.sort.rawValue
        let spec = CommentAPIs.fetchPostComment(postId, page, size, sort).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchComment(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func fetchComment(spec: APISpec, headers: [APIHeader]?) -> Single<PaginationResponsePostCommentResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Fetch PostComment Result: \(str)")
                }
            }
            .map(PaginationResponsePostCommentResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    
    
    // MARK: - Create Comment
    
    public func createComment(postId: String, body: CreatePostCommentReqeustDTO) -> Single<PostCommentResponse?> {
        let spec = CommentAPIs.createPostComment(postId).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.createComment(spec: spec, headers: $0.1, jsonEncodable: body) }
            .asSingle()
    }
    
    private func createComment(spec: APISpec, headers: [APIHeader]?, jsonEncodable body: Encodable) -> Single<PostCommentResponse?> {
        return request(spec: spec, headers: headers, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Create PostComment Result: \(str)")
                }
            }
            .map(PostCommentResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    
    
    // MARK: - Update Comment
    
    public func updateComment(postId: String, commentId: String, body: UpdatePostCommentReqeustDTO) -> Single<PostCommentResponse?> {
        let spec = CommentAPIs.updatePostComment(postId, commentId).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.updateComment(spec: spec, headers: $0.1, jsonEncodable: body) }
            .asSingle()
    }
    
    private func updateComment(spec: APISpec, headers: [APIHeader]?, jsonEncodable body: Encodable) -> Single<PostCommentResponse?> {
        return request(spec: spec, headers: headers, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Update PostComment Result: \(str)")
                }
            }
            .map(PostCommentResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    
    
    
    // MARK: - Delete Commen
    
    public func deleteComment(postId: String, commentId: String) -> Single<PostCommentDeleteResponse?> {
        let spec = CommentAPIs.deletePostComment(postId, commentId).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.deleteComment(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func deleteComment(spec: APISpec, headers: [APIHeader]?) -> Single<PostCommentDeleteResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Delete PostComment Result: \(str)")
                }
            }
            .map(PostCommentDeleteResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
}
