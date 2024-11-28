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

    /// postList를 불러옵니다. - 메인 화면에서 사용 중 입니다.
    /// 만약, userdefaults에 저장된 가족 멤버가 없다면, fetchFamily를 한 번 실행하여 post 정보를 가져옵니다.
    public func execute(query: PostListQuery) -> Observable<[PostEntity]?> {
        return postListRepository.fetchPostList(query: query)
            .flatMap { posts -> Single<[PostEntity]?> in
                guard let posts = posts else {
                    return Single.just(nil)
                }
                
                return self.loadFamilyMembersAndUpdatePosts(posts: posts.postLists)
            }
            .asObservable()
    }

    /// PostList를 페이지네이션 형태로 불러옵니다 - 프로필 조회에서 사용 중 입니다.
    public func execute(query: PostListQuery) -> Observable<PostListPageEntity?> {
        return postListRepository.fetchPostList(query: query)
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

extension FetchPostListUseCase {
    private func loadFamilyMembersAndUpdatePosts(posts: [PostEntity]) -> Single<[PostEntity]?> {
        let members = self.familyRepository.loadAllFamilyMembers()

        if let members = members {
            return self.updatePostsWithMembers(posts: posts, members: members)
        } else {
            return self.familyRepository.fetchFamilyMembers()
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
        
        return Single.just(updatedPosts)
    }
}
