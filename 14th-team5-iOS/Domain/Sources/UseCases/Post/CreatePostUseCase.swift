//
//  CreatePostUseCase.swift
//  Domain
//
//  Created by 김도현 on 11/22/24.
//

import Foundation

import RxSwift

public protocol CreatePostUseCaseProtocol {
    func execute(query: CreatePostQuery, body: CreatePostRequest) -> Observable<CreatePostEntity?>
}


public final class CreatePostUseCase: CreatePostUseCaseProtocol {
    private let postListRepository: PostListRepositoryProtocol
    
    public init(postListRepository: PostListRepositoryProtocol) {
        self.postListRepository = postListRepository
    }
    
    public func execute(query: CreatePostQuery, body: CreatePostRequest) -> Observable<CreatePostEntity?> {
        return postListRepository.createPostItem(query: query, body: body)
    }
}
