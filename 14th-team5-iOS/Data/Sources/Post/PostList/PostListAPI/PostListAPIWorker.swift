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

typealias PostListAPIWorker = PostListAPIs.Worker
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

extension PostListAPIWorker {
    public func fetchPostList(query: Domain.PostListQuery) -> RxSwift.Single<Domain.PostListPage> {
        let requestDTO = PostListRequestDTO(page: query.page, size: query.size, date: "2023-12-27", memberId: query.memberId, sort: query.sort)
        let spec = PostListAPIs.fetchPostList(requestDTO).spec
        return request(spec: spec, headers: [BibbiHeader.acceptJson, BibbiHeader.xAuthToken("eyJyZWdEYXRlIjoxNzAzNDA4MzI4MDg3LCJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwMzQ5NDcyOH0.V7Dw6RTWJ8BMzfJpuVCQz1Zhwj_cnI-r9oxYDjx3zJs")])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("PostList Fetch Result: \(str)")
                }
            }
            .map(PostListResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0!.toDomain() }
            .asSingle()
    }
}
