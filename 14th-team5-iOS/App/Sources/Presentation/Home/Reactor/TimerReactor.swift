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
    case allUploaded
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
    let provider: GlobalStateProviderProtocol
    
    let isSelfUploaded: Bool
    let isAllUploaded: Bool
    
    init(provider: GlobalStateProviderProtocol, isSelfUploaded: Bool, isAllUploaded: Bool) {
        self.provider = provider
        self.isSelfUploaded = isSelfUploaded
        self.isAllUploaded = isAllUploaded
    }
}

extension TimerReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .startTimer:
            return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .startWith(0)
                .map { _ in self.calculateRemainingTime() }
                .filter { $0 >= 0 }
                .flatMap { time in
                    var observables = [
                        Mutation.setTimer(time)
                    ]
        
                    if time <= 3600 && !self.isSelfUploaded {
                        observables.append(Mutation.setTimerType(.warning))
                    } else if self.isAllUploaded {
                        observables.append(Mutation.setTimerType(.allUploaded))
                    }  else {
                        observables.append(Mutation.setTimerType(.standard))
                    }
                    
                    return Observable.from(observables)
                }
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
        
        let isAfterNoon = calendar.component(.hour, from: currentTime) >= 12
        
        if isAfterNoon {
            if let nextMidnight = calendar.date(bySettingHour: 18, minute: 10, second: 0, of: /*currentTime.addingTimeInterval(24 * 60 * 60)*/ currentTime) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return max(0, timeDifference.second ?? 0)
            }
        }
        
        return 0
    }
}
