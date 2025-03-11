//
//  FetchPostUseCase.swift
//  Domain
//
//  Created by 마경미 on 25.02.25.
//

import Foundation

import RxSwift

public protocol FetchPostUseCaseProtocol {
    func execute(postId: String) -> Observable<PostDetailEntity>
}

enum PostDetailError: Error {
    case postNotFound
}

public final class FetchPostUseCase: FetchPostUseCaseProtocol {
    
    private let postRepository: PostRepositoryProtocol
    private let familyRepository: FamilyRepositoryProtocol
    
    public init(
        postRepository: PostRepositoryProtocol,
        familyRepository: FamilyRepositoryProtocol
    ) {
        self.familyRepository = familyRepository
        self.postRepository = postRepository
    }
    
    public func execute(postId: String) -> Observable<PostDetailEntity> {
        return Observable.zip(
            postRepository.fetchPostDetailItem(postId: postId),
            familyRepository.fetchFamilyMembers()
        )
        .flatMap { (post, members) -> Observable<PostDetailEntity> in
            guard var newPost = post else {
                return .error(PostDetailError.postNotFound)
            }
            
            newPost.author = members?.first(where: {
                $0.memberId == newPost.authorId
            })
            
            return .just(newPost)
        }
    }
}
