//
//  PostListUseCase.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation
import RxSwift

public protocol PostListUseCaseProtocol {
    func executePost(query: PostQuery) -> Single<PostData?>
    func excute(query: PostListQuery) -> Single<PostListPage?>
    func excute() -> Single<Bool>
}

public class PostListUseCase: PostListUseCaseProtocol {
    private let postListRepository: PostListRepositoryProtocol
    private let uploadPostRepository: UploadPostRepositoryProtocol?
    
    public init(postListRepository: PostListRepositoryProtocol, uploadePostRepository: UploadPostRepositoryProtocol? = nil) {
        self.postListRepository = postListRepository
        self.uploadPostRepository = uploadePostRepository
    }
    
    public func excute(query: PostListQuery) -> Single<PostListPage?> {
        return postListRepository.fetchTodayPostList(query: query)
    }
    
    public func executePost(query: PostQuery) -> Single<PostData?> {
        return postListRepository.fetchPostDetail(query: query)
    }
    
    public func excute() -> RxSwift.Single<Bool> {
        guard let uploadPostRepository = uploadPostRepository else { return .just(false)}
        return uploadPostRepository.checkPostUploadedToday()
    }
}
