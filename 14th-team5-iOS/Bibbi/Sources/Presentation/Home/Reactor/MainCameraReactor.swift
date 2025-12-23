//
//  MainCameraReactor.swift
//  App
//
//  Created by 마경미 on 30.04.24.
//

import UIKit
import Core
import Domain

import ReactorKit

final class MainCameraReactor: Reactor {
    enum Action {
        case setText(BalloonText)
        case checkMidnightStatus
    }
    
    enum Mutation {
        case updateText(BalloonText)
        case updateMidnightStatus(Bool)
    }
    
    struct State {
        var balloonText: BalloonText = .survivalStandard
        var isInMidnightPeriod: Bool = false
    }
    
    let initialState: State = State()
}

extension MainCameraReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setText(let text):
            return Observable.just(.updateText(text))
        case .checkMidnightStatus:
            return Observable<Int>.interval(.seconds(1), scheduler: RxScheduler.main)
                .map { _ in self.isInMidnightPeriod() }
                .distinctUntilChanged()
                .flatMap { isMidnight -> Observable<Mutation> in
                    if isMidnight {
                        return .concat([
                            .just(.updateMidnightStatus(true)),
                            .just(.updateText(.midNightStandard))
                        ])
                    } else {
                        return .just(.updateMidnightStatus(false))
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateText(let text):
            newState.balloonText = text
        case .updateMidnightStatus(let isMidnight):
            newState.isInMidnightPeriod = isMidnight
        }
        
        return newState
    }
}


extension MainCameraReactor {
    private func isInMidnightPeriod() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        return hour >= 0 && hour < 10
    }
}
