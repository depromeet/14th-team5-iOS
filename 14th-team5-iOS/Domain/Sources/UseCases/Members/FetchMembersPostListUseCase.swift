//
//  FetchMembersPostListUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/16/24.
//

import Foundation

import RxSwift
import RxCocoa

public protocol FetchMembersPostListUseCaseProtocol {
    func execute(query: PostListQuery) -> Observable<PostListPageEntity?>
}


public final class FetchMembersPostListUseCase: FetchMembersPostListUseCaseProtocol {
        
    private let postListRepository: any PostRepositoryProtocol
    
    
    public init(postListRepository: any PostRepositoryProtocol) {
        self.postListRepository = postListRepository
    }
    
    public func execute(query: PostListQuery) -> Observable<PostListPageEntity?> {
        return postListRepository.fetchPostList(query: query)
    }
    
    
}
