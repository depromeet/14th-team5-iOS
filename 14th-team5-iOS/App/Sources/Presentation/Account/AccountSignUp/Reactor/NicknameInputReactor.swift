//
//  NicknameInputReactor.swift
//  App
//
//  Created by geonhui Yu on 12/8/23.
//

import Foundation
import ReactorKit

final class NicknameInputReactor: Reactor {
    enum Action {
        case setNickname(String)
    }
    
    enum Mutation {
        case setNickname(String)
    }
    
    struct State {
        var nickname: String = ""
        var isValidNickname: Bool = false
    }
    
    let initialState: State = State()
}

extension NicknameInputReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setNickname(let nickname):
            Observable.just(Mutation.setNickname(nickname))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setNickname(let nickname):
            newState.nickname = nickname
            newState.isValidNickname = nickname.count <= 10
        }
        return newState
    }
}
