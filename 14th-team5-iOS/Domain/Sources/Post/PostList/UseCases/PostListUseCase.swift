//
//  PostListUseCase.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation
import RxSwift

protocol PostListUseCaseProtocol {
    func excute(query: PostListQuery) -> Single<PostListPage>
}

public class PostListUseCase: PostListUseCaseProtocol {
    private let postListRepository: PostListRepository
    
    init(postListRepository: PostListRepository) {
        self.postListRepository = postListRepository
    }
    
    func excute(query: PostListQuery) -> Single<PostListPage> {
        return postListRepository.fetchTodayPostList(query: query)
    }
    
}
