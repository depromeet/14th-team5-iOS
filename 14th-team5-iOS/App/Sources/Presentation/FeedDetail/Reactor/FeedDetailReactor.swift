//
//  FeedDetailReactor.swift
//  App
//
//  Created by 마경미 on 09.12.23.
//

import Foundation
import Core
import ReactorKit

final class FeedDetailReactor: Reactor {
    enum Action {
        case emojiButtonTapped
    }
    
    enum Mutation {
        case updateEmojiState
    }
    
    struct State {

    }
    
    let initialState: State = State()
}

extension FeedDetailReactor {
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
              return newState
        }
    }
}
