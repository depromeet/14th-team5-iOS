//
//  DateOfBirthReactor.swift
//  App
//
//  Created by geonhui Yu on 12/8/23.
//

import Foundation
import ReactorKit

final class DateOfBirthReactor: Reactor {
    enum Action {
        case setYear(Int)
        case setMonth(Int)
        case setDay(Int)
    }
    
    enum Mutation {
        case setYear(Int)
        case setMonth(Int)
        case setDay(Int)
    }
    
    struct State {
        var year: Int?
        var isValidYear: Bool = false
        var month: Int?
        var isValidMonth: Bool = false
        var day: Int?
        var isValidDay: Bool = false
    }
    
    let initialState: State = State()
}

extension DateOfBirthReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setYear(let year):
            Observable.just(Mutation.setYear(year))
        case .setMonth(let month):
            Observable.just(Mutation.setMonth(month))
        case .setDay(let day):
            Observable.just(Mutation.setDay(day))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setYear(let year):
            newState.year = year
            newState.isValidYear = year < 2023 // 현재 년도 구하는 로직
        case .setMonth(let month):
            newState.month = month
            newState.isValidYear = month < 13
        case .setDay(let day):
            newState.day = day
            newState.isValidDay = day < 31
        }
        return newState
    }
}
