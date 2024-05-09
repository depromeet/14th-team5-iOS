//
//  ContributorProfileReactor.swift
//  App
//
//  Created by 마경미 on 07.05.24.
//

import UIKit

import Domain

import ReactorKit

final class ContributorProfileReactor: Reactor {
    enum Action {
        case getRanker(RankerData?)
    }
    
    enum Mutation {
        case updateRanker(RankerData?)
    }

    struct State {
        let rank: Rank
        @Pulse var ranker: RankerData? = nil
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension ContributorProfileReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getRanker(let data):
            return Observable.just(.updateRanker(data))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateRanker(let data):
            newState.ranker = data
        }
        
        return newState
    }
}
