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
    }
    
    enum Mutation {
        case setPop
        case setSelectedPost(PostEntity)
        case setSelectedPostIndex(Int)
        case setMissionContent(MissionContentEntity)
        case setPushProfileViewController(String)
    }
    
    struct State {
        var selectedIndex: Int
        var originPostLists: PostSection.Model
        
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
    
    init(postId: String) {
        self.initialState = .init(
            selectedIndex: 0,
            originPostLists: .init(model: 0, items: [])
        )
        
        fetchPostUseCase.execute(postId: postId)
            .subscribe(onNext: { result in
                let post: PostEntity = .init(
                    postId: result.postId,
                    author: result.author ?? .init(memberId: "nil"),
                    commentCount: result.commentCount,
                    emojiCount: result.emojiCount,
                    imageURL: result.imageUrl,
                    content: result.content,
                    time: result.createdAt
                )
                self.initialState.originPostLists.items = .init(
                    with: .main(post)
                )
            })
            .disposed(by: disposeBag)
                
        self.action.onNext(.setPostId(postId))
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
        }
        return newState
    }
}
