//
//  StudioReactor.swift
//  Bibbi
//
//  Created by 마경미 on 22.09.25.
//

import Foundation

import ReactorKit
import Core

final class StudioPageReactor: Reactor {
    enum Action {
        case bannerClicked
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    let initialState: State = State()
    
    @Navigator var navigator: StudioNavigatorProtocol
}

extension StudioPageReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .bannerClicked:
                  navigator.to()
                  return .just(.openBanner)
              }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        }
        
        return newState
    }
}
