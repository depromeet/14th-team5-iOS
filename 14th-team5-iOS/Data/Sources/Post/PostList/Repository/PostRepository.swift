//
//  PostRepository.swift
//  Data
//
//  Created by Kim dohyun on 6/6/24.
//

import Foundation

import Domain
import RxSwift

public final class PostRepository: PostListRepositoryProtocol {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let postAPIWorker: PostAPIWorker = PostAPIWorker()
    
    public init() { }
    
    public func fetchPostDetail(query: Domain.PostQuery) -> RxSwift.Single<Domain.PostData?> {
        return postAPIWorker.fetchPostDetail(query: query)
    }
    
    public func fetchTodayPostList(query: Domain.PostListQuery) -> RxSwift.Single<Domain.PostListPage?> {
        return postAPIWorker.fetchTodayPostList(query: query)
    }
}
