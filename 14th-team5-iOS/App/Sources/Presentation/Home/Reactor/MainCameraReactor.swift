//
//  MainCameraReactor.swift
//  App
//
//  Created by 마경미 on 30.04.24.
//

import UIKit

import Domain

import ReactorKit

enum BalloonText: String {
    case survivalStandard = "하루에 한번 사진을 올릴 수 있어요"
    case cantMission = "아직 미션 사진을 찍을 수 없어요"
    case canMission = "미션 사진을 찍으러 가볼까요?"
}

final class MainCameraReactor: Reactor {
    enum Action {
        case setText(BalloonText)
    }
    
    enum Mutation {
        case setText(BalloonText)
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
            return Observable.just(.setText(text))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setText(let text):
            newState.balloonText = text
        }
        
        return newState
    }
}
