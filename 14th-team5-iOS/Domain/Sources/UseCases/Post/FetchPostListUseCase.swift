//
//  PostListUseCase.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation
import RxSwift

public protocol FetchPostListUseCaseProtocol {
    func excute(query: PostListQuery) -> Single<PostListPageEntity?>
}

public class FetchPostListUseCase: FetchPostListUseCaseProtocol {
    private let postListRepository: PostListRepositoryProtocol
    
    public init(postListRepository: PostListRepositoryProtocol) {
        self.postListRepository = postListRepository
    }
    
    public func excute(query: PostListQuery) -> Single<PostListPageEntity?> {
        return postListRepository.fetchTodayPostList(query: query)
    }
}
