//
//  TimerReactor.swift
//  App
//
//  Created by 마경미 on 30.01.24.
//

import Foundation

import ReactorKit
import Core

enum TimerType {
    case standard
    case warning
}

final class TimerReactor: Reactor {
    enum Action {
        case startTimer
    }
    
    enum Mutation {
        case setTimerType(TimerType)
        case setTimer(Int)
    }
    
    struct State {
        @Pulse var time: Int = 0
        var timerType: TimerType = .standard
    }
    
    let initialState: State = State()
}

extension TimerReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startTimer:
            let timerObservable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .startWith(0)
                .map { _ in return self.calculateRemainingTime() }
                .flatMap { time -> Observable<Mutation> in
                    if time <= 0 {
                        return Observable.from([
                            Mutation.setTimer(0),
                            Mutation.setTimerType(.standard)
                            ])
                    } else if time <= 3600 {
                        return Observable.from([
                            Mutation.setTimer(time),
                            Mutation.setTimerType(.warning)
                        ])
                    } else {
                        return Observable.from([
                            Mutation.setTimer(time),
                            Mutation.setTimerType(.standard)
                            ])
                    }
                }
            return timerObservable
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTimerType(let type):
            newState.timerType = type
        case .setTimer(let time):
            newState.time = time
        }
        
        return newState
    }
}

extension TimerReactor {
    private func calculateRemainingTime() -> Int {
        let calendar = Calendar.current
        let currentTime = Date()
        
        let isAfterNoon = calendar.component(.hour, from: currentTime) >= 10
        
        if isAfterNoon {
            if let nextMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentTime.addingTimeInterval(24 * 60 * 60)) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return max(0, timeDifference.second ?? 0)
            }
        }
        
        return 0
    }
}
