//
//  PostListAPIWorker.swift
//  Data
//
//  Created by 마경미 on 25.12.23.
//

import Foundation
import Domain

import Alamofire
import RxSwift

public typealias PostListAPIWorker = PostListAPIs.Worker
extension PostListAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "PostListAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "PostListAPIWorker"
        }
    }
}

extension PostListAPIWorker: PostListRepositoryProtocol {
    public func fetchPostDetail(query: Domain.PostQuery) -> RxSwift.Single<Domain.PostData?> {
        let requestDTO = PostRequestDTO(postId: query.postId)
        let spec = PostListAPIs.fetchPostDetail(requestDTO).spec
<<<<<<< HEAD
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MiLCJyZWdEYXRlIjoxNzA0MTk2NjA2NjE2fQ.eyJ1c2VySWQiOiIwMUhKQk5XWkdOUDFLSk5NS1dWWkowMzlIWSIsImV4cCI6MTcwNDI4MzAwNn0._q3bFjpqj0_WGnE8GOXTXWzXy-V8YkHGbmEtYbQ89cA")])
=======
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJ0eXBlIjoiYWNjZXNzIiwicmVnRGF0ZSI6MTcwNDI1OTk2MzUzNiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDM0NjM2M30.xBr6OPTTXysKQCQKXgm4QRSx3uCWxHC45W0I7UUjcwE")])
>>>>>>> c768778 (feat: add emoji apis (#158))
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("PostDetail Fetch Result: \(str)")
                }
            }
            .map(PostResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchTodayPostList(query: Domain.PostListQuery) -> RxSwift.Single<Domain.PostListPage?> {
        let requestDTO = PostListRequestDTO(page: query.page, size: query.size, date: query.date, memberId: query.memberId, sort: query.sort)
        let spec = PostListAPIs.fetchPostList(requestDTO).spec
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJ0eXBlIjoiYWNjZXNzIiwicmVnRGF0ZSI6MTcwNDI1OTk2MzUzNiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDM0NjM2M30.xBr6OPTTXysKQCQKXgm4QRSx3uCWxHC45W0I7UUjcwE")])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("PostList Fetch Result: \(str)")
                }
            }
            .map(PostListResponseDTO.self)
            .catchAndReturn(nil)
            .map { 
                let selfUploaded = $0?.results.map { $0.authorId == FamilyUserDefaults.getMyMemberId() }.isEmpty
                let familyUploaded = $0?.results.count == FamilyUserDefaults.getMemberCount()
                return $0?.toDomain(selfUploaded ?? false, familyUploaded)
            }
            .asSingle()
    }
}
