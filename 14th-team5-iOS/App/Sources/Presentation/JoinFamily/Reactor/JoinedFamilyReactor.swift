//
//  JoinedFamilyReactor.swift
//  App
//
//  Created by geonhui Yu on 2/8/24.
//

import Core
import Domain

import ReactorKit

public final class JoinedFamilyReactor: Reactor {
    public enum Action {
        case enterFamily
        case joinFamily
    }
    
    public enum Mutation {
        case setHomeView(Bool)
        case setShowJoinFamily(Bool)
    }
    
    public struct State {
        var isShowHome: Bool = false
        var isShowJoinFamily: Bool = false
    }
    
    public var initialState: State
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension JoinedFamilyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .enterFamily:
            return Observable.just(.setHomeView(true))
        case .joinFamily:
            return Observable.just(.setShowJoinFamily(true))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setHomeView(let isShow):
            newState.isShowHome = isShow
        case .setShowJoinFamily(let isShow):
            newState.isShowJoinFamily = isShow
        }
        return newState
    }
}
