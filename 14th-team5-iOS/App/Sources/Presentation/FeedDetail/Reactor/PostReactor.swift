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
        case fetchPost(String)
    }
    
    enum Mutation {
        case fetchedPost(PostData)
    }
    
    struct State {
        let originPostLists: [SectionModel<String,PostListData>]
//        let fetchedPostLists: [SectionModel<String, PostData>] 
        let selectedPostIndex: Int
        var fetchedPost: PostData = .init(writer: "", time: "", imageURL: "", imageText: "", emojis: [])
    }
    
    let initialState: State
    
    let postRepository: PostListUseCaseProtocol
    
    init(postRepository: PostListUseCaseProtocol, initialState: State) {
        self.postRepository = postRepository
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
                    return Observable.just(Mutation.fetchedPost(post ?? .init(writer: "", time: "", imageURL: "", imageText: "", emojis: [])))
                }
        }
    }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var newState = state
            switch mutation {
            case let .fetchedPost(post):
                newState.fetchedPost = post
            }
            return newState
        }
}
