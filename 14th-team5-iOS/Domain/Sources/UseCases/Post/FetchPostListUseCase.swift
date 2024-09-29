//
//  PostListUseCase.swift
//  Domain
//
//  Created by 마경미 on 25.12.23.
//

import Foundation
import RxSwift

public protocol FetchPostListUseCaseProtocol {
    func execute(query: PostListQuery) -> Observable<PostListPageEntity?>
    func execute(query: PostListQuery) -> Observable<[PostEntity]?>
}

public class FetchPostListUseCase: FetchPostListUseCaseProtocol {
    private let postListRepository: PostListRepositoryProtocol
    private let familyRepository: FamilyRepositoryProtocol
    
    public init(
        postListRepository: PostListRepositoryProtocol,
        familyRepository: FamilyRepositoryProtocol
    ) {
        self.postListRepository = postListRepository
        self.familyRepository = familyRepository
    }

    public func execute(query: PostListQuery) -> Observable<[PostEntity]?> {
        return postListRepository.fetchTodayPostList(query: query)
            .flatMap { posts -> Single<[PostEntity]?> in
                guard let posts = posts else {
                    return Single.just(nil)
                }
                
                return self.loadFamilyMembersAndUpdatePosts(posts: posts.postLists)
            }
            .asObservable()
    }

    private func loadFamilyMembersAndUpdatePosts(posts: [PostEntity]) -> Single<[PostEntity]?> {
        let members = self.familyRepository.loadAllFamilyMembers()

        if let members = members {
            return self.updatePostsWithMembers(posts: posts, members: members)
        } else {
            return self.familyRepository.fetchAllFamilyMembers()
                .flatMap { membersFromApi -> Single<[PostEntity]?> in
                    return self.updatePostsWithMembers(posts: posts, members: membersFromApi)
                }
                .asSingle()
        }
    }

    private func updatePostsWithMembers(posts: [PostEntity], members: [Profile]?) -> Single<[PostEntity]?> {
        guard let members = members else {
            return Single.just(nil)
        }
        
        let updatedPosts = posts.map { post in
            var updatedPost = post
            if let member = members.first(where: { $0.memberId == updatedPost.author.memberId }) {
                updatedPost.author = member
            }
            return updatedPost
        }
        
        return Single.just(updatedPosts) // updatedPosts를 Single로 반환
    }
    
    public func execute(query: PostListQuery) -> Observable<PostListPageEntity?> {
        return postListRepository.fetchTodayPostList(query: query)
            .flatMap { posts -> Single<PostListPageEntity?> in
                let members = self.familyRepository.loadAllFamilyMembers()
                
                guard let posts = posts,
                      let members = members else {
                    return Single.just(nil)
                }
                
                var updatedPosts = posts
                updatedPosts.postLists = posts.postLists.map { post in
                    var updatedPost = post
                    if let member = members.first(where: { $0.memberId == updatedPost.author.memberId }) {
                        updatedPost.author = member
                    }
                    return updatedPost
                }
                
                return Single.just(updatedPosts)
            }
            .asObservable()
    }
}
