//
//  PostCommentAPIWorker.swift
//  Data
//
//  Created by 김건우 on 1/17/24.
//

import Core
import Domain
import Foundation

import RxSwift

typealias PostCommentAPIWorker = PostCommentAPIs.Worker
extension PostCommentAPIs {
    final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "PostCommentAPIWorker", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "PostCommentAPIWorker"
        }
        
        // MARK: Values
        private var _headers: Observable<[APIHeader]?> {
            return App.Repository.token.accessToken
                .map {
                    guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                    return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken)]
                }
        }
    }
}

extension PostCommentAPIWorker {
    public func fetchPostComment(postId: String, query: PostCommentPaginationQuery) -> Single<PaginationResponsePostCommentResponse?> {
        let page = query.page
        let size = query.size
        let sort = query.sort.rawValue
        let spec = PostCommentAPIs.getPostComment(postId, page, size, sort).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchPostComment(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func fetchPostComment(spec: APISpec, headers: [APIHeader]?) -> Single<PaginationResponsePostCommentResponse?> {
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
    
    public func addPostComment(postId: String, body: CreatePostCommentQuery) -> Single<PostCommentResponse?> {
        let spec = PostCommentAPIs.addPostComment(postId).spec
        let body = CreatePostCommentReqeustDTO(content: body.content)
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.addPostComment(spec: spec, headers: $0.1, jsonEncodable: body) }
            .asSingle()
    }
    
    private func addPostComment(spec: APISpec, headers: [APIHeader]?, jsonEncodable body: Encodable) -> Single<PostCommentResponse?> {
        return request(spec: spec, headers: headers, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .map(PostCommentResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func updatePostComment(postId: String, commentId: String, body: UpdatePostCommentQuery) -> Single<PostCommentResponse?> {
        let spec = PostCommentAPIs.updatePostComment(postId, commentId).spec
        let body = UpdatePostCommentReqeustDTO(content: body.content)
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.updatePostComment(spec: spec, headers: $0.1, jsonEncodable: body) }
            .asSingle()
    }
    
    private func updatePostComment(spec: APISpec, headers: [APIHeader]?, jsonEncodable body: Encodable) -> Single<PostCommentResponse?> {
        return request(spec: spec, headers: headers, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .map(PostCommentResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func deletePostComment(postId: String, commentId: String) -> Single<PostCommentDeleteResponse?> {
        let spec = PostCommentAPIs.deletePostComment(postId, commentId).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.deletePostComment(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func deletePostComment(spec: APISpec, headers: [APIHeader]?) -> Single<PostCommentDeleteResponse?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .map(PostCommentDeleteResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
}
