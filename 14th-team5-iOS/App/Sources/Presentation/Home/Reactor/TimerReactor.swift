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
//        var time: Int = 0
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
                .flatMap { _ in
                    let time = self.calculateRemainingTime()
                    
                    guard time > 0 else {
                        self.provider.timerGlobalState.setNotTime()
                        return Observable.from([Mutation.setTimer(0), Mutation.setTimerType(.standard)])
                    }

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
        
//        switch action {
//        case .startTimer:
//            // 12시에 한 번만 이벤트를 방출하는 Observable 생성
//            let twelveClockEvent = Observable<Int>
//                .timer(.seconds(Int(Date().next(calendarComponent: .day, value: 1, hour: 12).timeIntervalSinceNow)), scheduler: MainScheduler.instance)
//                .map { _ in return () }
//                .startWith(())
//
//            let timerObservable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//                .startWith(0)
//                .flatMap { _ in
//                    let time = self.calculateRemainingTime()
//                    
//                    guard time > 0 else {
//                        self.provider.timerGlobalState.setNotTime()
//                        return Observable.from([Mutation.setTimer(0), Mutation.setTimerType(.standard)])
//                    }
//                    
//                    var observables = [Mutation.setTimer(time)]
//                    
//                    if time <= 3600 && !self.isSelfUploaded {
//                        observables.append(Mutation.setTimerType(.warning))
//                    } else if self.isAllUploaded {
//                        observables.append(Mutation.setTimerType(.allUploaded))
//                    }  else {
//                        observables.append(Mutation.setTimerType(.standard))
//                    }
//                    
//                    return Observable.from(observables)
//                }
//            
//            // 타이머 Observable과 12시 이벤트 Observable을 병합
//            return Observable.merge(timerObservable, twelveClockEvent.map { _ in Mutation.setTimer(0) })
//        }
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
            if let nextMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentTime.addingTimeInterval(24 * 60 * 60)) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return max(0, timeDifference.second ?? 0)
            }
        }
        
        return 0
    }
}

extension Date {
    func next(calendarComponent: Calendar.Component, value: Int, hour: Int) -> Date {
        let calendar = Calendar.current
        return calendar.nextDate(after: self, matching: DateComponents(hour: hour), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward) ?? self
    }
}
