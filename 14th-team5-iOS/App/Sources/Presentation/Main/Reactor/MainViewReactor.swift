//
//  MainViewReactor.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation
import ReactorKit

class MainViewReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State = State()
}

extension MainViewReactor {
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
