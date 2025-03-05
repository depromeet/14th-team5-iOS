//
//  PostReactor.swift
//  App
//
//  Created by 마경미 on 09.12.23.
//

import Foundation
import Core
import Domain

import ReactorKit
import RxDataSources

final class PostReactor: Reactor {
    enum Action {
        case tapBackButton
        case setPostIndex(Int)
        case setPostId(String)
        case fetchPost(PostEntity)
    }
    
    enum Mutation {
        case setPop
        case setPostLists(PostSection.Model)
        case setSelectedPost(PostEntity)
        case setSelectedPostIndex(Int)
        case setMissionContent(MissionContentEntity)
        case setPushProfileViewController(String)
    }
    
    struct State {
        var selectedIndex: Int
        @Pulse var originPostLists: PostSection.Model
        
        var isPop: Bool = false
        
        @Pulse var selectedPost: PostEntity? = nil
        @Pulse var missionContent: MissionContentEntity? = nil
        
        @Pulse var reactionMemberIds: [String] = []
        @Pulse var shouldPushProfileViewController: String?
    }
    
    var initialState: State
    private let disposeBag: DisposeBag = DisposeBag()
    
    @Injected var fetchMemberUseCase: FetchFamilyMembersUseCaseProtocol
    @Injected var fetchPostUseCase: FetchPostUseCaseProtocol
    @Injected var fetchMissionUseCase: FetchMissionContentUseCaseProtocol
    @Injected var provider: ServiceProviderProtocol
    
    init(
        selectedIndex: Int,
        originPostLists: PostSection.Model
    ) {
        self.initialState = .init(
            selectedIndex: selectedIndex,
            originPostLists: originPostLists
        )
    }
    
    init(postId: String?) {
        self.initialState = .init(
            selectedIndex: 0,
            originPostLists: .init(model: 0, items: [])
        )
        
        
        guard let postId else {
            BBLogger.logError(function: "postId 값이 없습니다.") 
            return
        }
        
        fetchPostUseCase.execute(postId: postId)
            .withUnretained(self)
            .bind(onNext: { _, result in
                let post: PostEntity = .init(
                    postId: result.postId,
                    author: result.author ?? .init(memberId: "nil"),
                    commentCount: result.commentCount,
                    emojiCount: result.emojiCount,
                    imageURL: result.imageUrl,
                    content: result.content,
                    time: result.createdAt
                )
                
                self.action.onNext(.fetchPost(post))

            }).disposed(by:disposeBag)
                
    }
}

extension PostReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let postMutation = provider.postGlobalState.event
            .flatMap { event in
                switch event {
                case let .pushProfileViewController(memberId):
                    return Observable<Mutation>.just(.setPushProfileViewController(memberId))
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable.merge(mutation, postMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setPostIndex(index):
            guard !currentState.originPostLists.items.isEmpty else {
                return Observable<Mutation>.empty()
            }
            guard case let .main(postEntity) = currentState.originPostLists.items[index],
                  let missionId = postEntity.missionId else { return Observable<Mutation>.just(.setSelectedPostIndex(index)) }
            return fetchMissionUseCase.execute(missionId: missionId)
                .asObservable()
                .flatMap { entity -> Observable<Mutation> in
                    return .concat(
                        .just(.setSelectedPostIndex(index)),
                        .just(.setMissionContent(entity))
                    )
                    
                }
        case .tapBackButton:
            return Observable.just(Mutation.setPop)
        case let .setPostId(postId):
            return fetchPostUseCase.execute(postId: postId)
                .flatMap { result -> Observable<Mutation> in
                    let post: PostEntity = .init(
                        postId: result.postId,
                        author: result.author ?? .init(memberId: "nil"),
                        commentCount: result.commentCount,
                        emojiCount: result.emojiCount,
                        imageURL: result.imageUrl,
                        content: result.content,
                        time: result.createdAt
                    )
                    return .just(.setSelectedPost(post))
                }
                
        case let .fetchPost(post):
            return .just(.setPostLists(.init(model: 0, items: [.main(post)])))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSelectedPostIndex(index):
            if case let .main(postData) = newState.originPostLists.items[index] {
                newState.selectedPost = postData
            }
            newState.selectedIndex = index
        case .setPop:
            newState.isPop = true
            
        case let .setPushProfileViewController(memberId):
            newState.shouldPushProfileViewController = memberId
        case let .setMissionContent(missionContent):
            provider.postGlobalState.missionContentText(missionContent.missionContent)
            newState.missionContent = missionContent
        case let .setSelectedPost(post):
            newState.selectedPost = post
        case let .setPostLists(postList):
            newState.originPostLists = postList
        }
        return newState
    }
}
