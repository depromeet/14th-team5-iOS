//
//  TempReactor.swift
//  App
//
//  Created by 마경미 on 28.01.24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class TempReactor: Reactor {
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    var initialState: State = State()
}

extension TempReactor {
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
