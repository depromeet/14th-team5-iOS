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
        case fetchPost(String)
    }
    
    enum Mutation {
        case setPop
        case setSelectedPostIndex(Int)
        case fetchedPost(PostData?)
    }
    
    struct State {
        var isPop: Bool = false
        let originPostLists: [SectionModel<String,PostListData>]
//        let fetchedPostLists: [SectionModel<String, PostData>] 
        var selectedPost: PostListData = .init(postId: "", author: .init(memberId: "", profileImageURL: "", name: ""), emojiCount: 0, imageURL: "", content: "", time: "")
        var fetchedPost: PostData? = nil
        var fetchedEmoji: FetchEmojiList = .init(reactions: [])
    }
    
    let initialState: State
    
    let postRepository: PostListUseCaseProtocol
    let emojiRepository: EmojiUseCaseProtocol
    
    init(postRepository: PostListUseCaseProtocol, emojiRepository: EmojiUseCaseProtocol, initialState: State) {
        self.postRepository = postRepository
        self.emojiRepository = emojiRepository
        self.initialState = initialState
    }
}

extension PostReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .fetchPost(postId):
            let query: PostQuery = PostQuery(postId: postId)
            return postRepository.excute(query: query)
                .asObservable()
                .flatMap { post in
                    return Observable.just(Mutation.fetchedPost(post))
                }
        case let .setPost(index):
            return Observable.just(Mutation.setSelectedPostIndex(index))
        case .tapBackButton:
            return Observable.just(Mutation.setPop)
        }
    }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var newState = state
            switch mutation {
            case let .fetchedPost(post):
                newState.fetchedPost = post
            case let .setSelectedPostIndex(index):
                newState.selectedPost = newState.originPostLists[0].items[index]
            case .setPop:
                newState.isPop = true
            }
            return newState
        }
}
