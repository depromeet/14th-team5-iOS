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

final class PostReactor: Reactor {
    enum Action {

    }
    
    enum Mutation {

    }
    
    struct State {
        let postLists: PostListData
        let selectedPostIndex: Int
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
        }
    }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var newState = state
            switch mutation {
            }
            return newState
        }
}
