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
    
    public func fetchTodayPostList(query: Domain.PostListQuery) -> RxSwift.Single<Domain.PostListPageEntity?> {
        return postAPIWorker.fetchTodayPostList(query: query)
    }
}
