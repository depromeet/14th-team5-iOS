//
//  EmojiReactor.swift
//  App
//
//  Created by 마경미 on 12.12.23.
//

import Foundation
import Core
import ReactorKit

final class EmojiReactor: Reactor {
    enum Action {
        case emojiButtonTapped(Int)
    }
    
    enum Mutation {
        case updateEmojiState
    }
    
    struct State {
        var emojiCount = 0
    }
    
    let initialState: State = State()
}

extension EmojiReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .emojiButtonTapped:
            return Observable.just(Mutation.updateEmojiState)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateEmojiState:
            newState.emojiCount += 1
              return newState
        }
    }
}

