//
//  ContributorReactor.swift
//  App
//
//  Created by 마경미 on 19.04.24.
//

import Foundation

import Domain

import ReactorKit

final class ContributorReactor: Reactor {
    enum Action {
        case setContributor(FamilyRankData)
    }
    
    enum Mutation {
        case updateState(FamilyRankData)
    }

    struct State {
        @Pulse var rank: FamilyRankData = .empty
    }
    
    let initialState: State = State()
}

extension ContributorReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setContributor(let contributor):
            return Observable.just(.updateState(contributor))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateState(let contributor):
            newState.rank = contributor
        }
        
        return newState
    }
}
