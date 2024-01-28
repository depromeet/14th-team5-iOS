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
        case fetchReaction
    }
    
    enum Mutation {
        case setPop
        case setSelectedPostIndex(Int)
        case showReactionSheet([String])
        case presentPostCommentSheet(String, Int)
        case fetchedReaction([FetchEmojiData])
    }
    
    struct State {
        let selectedIndex: Int
        let originPostLists: PostSection.Model
        
        var isPop: Bool = false
        var selectedPost: PostListData = .init(postId: "", author: .init(memberId: "", profileImageURL: "", name: ""), commentCount: 0, emojiCount: 0, imageURL: "", content: "", time: "")
        
        @Pulse var fetchedPost: PostData? = nil
        @Pulse var reactionMemberIds: [String] = []
        @Pulse var shouldPresentPostCommentSheet: (String, Int) = (.none, 0)
        @Pulse var fetchedReaction: [EmojiData]? = nil
    }
    
    let initialState: State
    
    let realEmojiRepository: RealEmojiUseCaseProtocol
    let emojiRepository: EmojiUseCaseProtocol
    let provider: GlobalStateProviderProtocol
    
    init(provider: GlobalStateProviderProtocol, realEmojiRepository: RealEmojiUseCaseProtocol, emojiRepository: EmojiUseCaseProtocol, initialState: State) {
        self.provider = provider
        self.realEmojiRepository = realEmojiRepository
        self.emojiRepository = emojiRepository
        self.initialState = initialState
    }
}

extension PostReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.reactionSheetGloablState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .showReactionMemberSheet(memberIds):
                    return Observable<Mutation>.just(.showReactionSheet(memberIds))
                }
            }
        
        let postMutation = provider.postGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .presentPostCommentSheet(postId, commentCount):
                    return Observable<Mutation>.just(.presentPostCommentSheet(postId, commentCount))
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation, postMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setPost(index):
            return Observable.just(Mutation.setSelectedPostIndex(index))
        case .tapBackButton:
            return Observable.just(Mutation.setPop)
        case .fetchReaction:
            let reactionQuery: FetchEmojiQuery = FetchEmojiQuery(postId: currentState.selectedPost.postId)
            let realEmojiQuery: FetchRealEmojiQuery = FetchRealEmojiQuery(postId: currentState.selectedPost.postId)

            let observable1 = emojiRepository.execute(query: reactionQuery).asObservable()
            let observable2 = realEmojiRepository.execute(query: realEmojiQuery).asObservable()

            return Observable.combineLatest(observable1, observable2) { result1, result2 in
                print(result1, result2)
                return .fetchedReaction(result1 ?? [])
            }
            return Observable.empty()
        }
    }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var newState = state
            switch mutation {
            case let .setSelectedPostIndex(index):
                if case let .main(postData) = newState.originPostLists.items[index] {
                    newState.selectedPost = postData
                }
            case .setPop:
                newState.isPop = true
            case let .showReactionSheet(memberIds):
                newState.reactionMemberIds = memberIds
                
            case let .presentPostCommentSheet(postId, commentCount):
                newState.shouldPresentPostCommentSheet = (postId, commentCount)
            case let .fetchedReaction(reaction):
                break
            }
            return newState
        }
}
