//
//  PostListAPIWorker.swift
//  Data
//
//  Created by 마경미 on 25.12.23.
//

import Foundation

import Core
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
        
        private var _headers: Observable<[APIHeader]?> {
            return App.Repository.token.accessToken
                .map {
                    guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                    return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken), BibbiAPI.Header.acceptJson]
                }
        }
    }
}

extension PostListAPIWorker: PostListRepositoryProtocol {
    public func fetchPostDetail(query: PostQuery) -> Single<PostData?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.fetchPostDetail(headers: $0.1, query: query) }
            .asSingle()
    }
    
    private func fetchPostDetail(headers: [APIHeader]?, query: Domain.PostQuery) -> RxSwift.Single<Domain.PostData?> {
        let requestDTO = PostRequestDTO(postId: query.postId)
        let spec = PostListAPIs.fetchPostDetail(requestDTO).spec
        return request(spec: spec, headers: headers)
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
    
    public func fetchTodayPostList(query: PostListQuery) -> Single<PostListPage?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.fetchTodayPostList(headers: $0.1, query: query) }
            .asSingle()
    }
    
    private func fetchTodayPostList(headers: [APIHeader]?, query: Domain.PostListQuery) -> RxSwift.Single<Domain.PostListPage?> {
        let requestDTO = PostListRequestDTO(page: query.page, size: query.size, date: query.date, memberId: nil, sort: query.sort, type: query.type.rawValue)
        let spec = PostListAPIs.fetchPostList.spec
        return request(spec: spec, headers: headers, parameters: requestDTO)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("PostList Fetch Result: \(str)")
                }
            }
            .map(PostListResponseDTO.self)
            .map {
                let myMemberId = FamilyUserDefaults.getMyMemberId()
                let familyCount = FamilyUserDefaults.getMemberCount()
                
                let selfUploaded = $0?.results.map { $0.authorId == myMemberId }.contains(true) ?? false
                let familyUploaded = $0?.results.count == familyCount
                
                if selfUploaded {
                    let repository = PostUserDefaultsRepository()
                    repository.checkUploadDate(date: query.date)
                }

                return $0?.toDomain(selfUploaded, familyUploaded)
            }
            .catchAndReturn(nil)
            .asSingle()
    }
}
