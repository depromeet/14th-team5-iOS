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
        case setPost(Int)
    }
    
    enum Mutation {
        case setPop
        case setSelectedPostIndex(Int)
        case setMissionContent(MissionContentResponse)
        case setPushProfileViewController(String)
    }
    
    struct State {
        var selectedIndex: Int
        let originPostLists: PostSection.Model
        
        var isPop: Bool = false
        var selectedPost: PostListData = .init(postId: "", author: .init(memberId: "", profileImageURL: "", name: ""), commentCount: 0, emojiCount: 0, imageURL: "", content: "", time: "")
        
        @Pulse var missionContent: MissionContentResponse? = nil
        @Pulse var fetchedPost: PostData? = nil
        @Pulse var reactionMemberIds: [String] = []
        @Pulse var shouldPushProfileViewController: String?
        
        var notificationDeepLink: NotificationDeepLink?
    }
    
    let initialState: State
    
    let realEmojiRepository: RealEmojiUseCaseProtocol
    let emojiRepository: EmojiUseCaseProtocol
    let missionUseCase: MissionContentUseCaseProtocol
    let provider: GlobalStateProviderProtocol
    
    
    init(
        provider: GlobalStateProviderProtocol,
        realEmojiRepository: RealEmojiUseCaseProtocol,
        emojiRepository: EmojiUseCaseProtocol,
        missionUseCase: MissionContentUseCaseProtocol,
        initialState: State
    ) {
        self.provider = provider
        self.realEmojiRepository = realEmojiRepository
        self.emojiRepository = emojiRepository
        self.missionUseCase = missionUseCase
        self.initialState = initialState
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
        case let .setPost(index):
            guard case let .main(postEntity) = currentState.originPostLists.items[index],
                  let missionId = postEntity.missionId else { return Observable<Mutation>.just(.setSelectedPostIndex(index)) }
            return missionUseCase.execute(missionId: missionId)
                .flatMap { entity -> Observable<Mutation> in
                    return .concat(
                        .just(.setSelectedPostIndex(index)),
                        .just(.setMissionContent(entity))
                    )
                    
                }
        case .tapBackButton:
            return Observable.just(Mutation.setPop)
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
        }
        return newState
    }
}
