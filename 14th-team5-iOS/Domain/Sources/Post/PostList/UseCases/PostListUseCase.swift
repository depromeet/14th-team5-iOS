//
//  PostListUseCase.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation
import RxSwift

public protocol PostListUseCaseProtocol {
    func excute(query: PostQuery) -> Single<PostData?>
    func excute(query: PostListQuery) -> Single<PostListPage?>
}

public class PostListUseCase: PostListUseCaseProtocol {
    private let postListRepository: PostListRepository
    
    public init(postListRepository: PostListRepository) {
        self.postListRepository = postListRepository
    }
    
    public func excute(query: PostListQuery) -> Single<PostListPage?> {
        return postListRepository.fetchTodayPostList(query: query)
    }
    
    public func excute(query: PostQuery) -> Single<PostData?> {
        return postListRepository.fetchPostDetail(query: query)
    }
}
