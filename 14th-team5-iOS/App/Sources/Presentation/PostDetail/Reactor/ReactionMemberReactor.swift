//
//  ReactionMemberReactor.swift
//  App
//
//  Created by 마경미 on 07.01.24.
//

import Foundation
import Core
import Domain

import ReactorKit
import RxDataSources

final class ReactionMemberReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
    }
    
    struct State {
        let reactionMemberIds: [String]
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension ReactionMemberReactor {
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
