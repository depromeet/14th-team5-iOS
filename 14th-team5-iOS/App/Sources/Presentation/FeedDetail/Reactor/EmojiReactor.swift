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
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State = State()
}

extension EmojiReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        }
    }
}
