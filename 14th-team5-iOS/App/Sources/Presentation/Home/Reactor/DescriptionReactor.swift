//
//  DescriptionReacto.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class DescriptionReactor: Reactor {
    enum Action {
        case setPostType(PostType)
    }
    
    enum Mutation {
        case setPostType(PostType)
    }
    
    struct State {
        var postType: PostType = .survival
    }
    
    let initialState: State = State()
}

extension DescriptionReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setPostType(let type):
            return Observable.just(.setPostType(type))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setPostType(let type):
            newState.postType = type
        }
        
        return newState
    }
}
