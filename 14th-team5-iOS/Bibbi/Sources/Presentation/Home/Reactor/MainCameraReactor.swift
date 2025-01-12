//
//  MainCameraReactor.swift
//  App
//
//  Created by 마경미 on 30.04.24.
//

import UIKit

import Domain

import ReactorKit

final class MainCameraReactor: Reactor {
    enum Action {
        case setText(BalloonText)
    }
    
    enum Mutation {
        case updateText(BalloonText)
    }
    
    struct State {
        var balloonText: BalloonText = .survivalStandard
    }
    
    let initialState: State = State()
}

extension MainCameraReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setText(let text):
            return Observable.just(.updateText(text))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateText(let text):
            newState.balloonText = text
        }
        
        return newState
    }
}
