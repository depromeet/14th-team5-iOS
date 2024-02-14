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
    }
    
    struct State {
        let selectedIndex: Int
        let originPostLists: PostSection.Model
        
        var isPop: Bool = false
        var selectedPost: PostListData = .init(postId: "", author: .init(memberId: "", profileImageURL: "", name: ""), commentCount: 0, emojiCount: 0, imageURL: "", content: "", time: "")
        
        @Pulse var fetchedPost: PostData? = nil
        @Pulse var reactionMemberIds: [String] = []
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
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setPost(index):
            return Observable.just(Mutation.setSelectedPostIndex(index))
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
        case .setPop:
            newState.isPop = true
        }
        return newState
    }
}
