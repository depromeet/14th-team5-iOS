//
//  AccountSignUpReactor.swift
//  App
//
//  Created by geonhui Yu on 12/8/23.
//

import Foundation
import Data

import ReactorKit

fileprivate typealias _Str = AccountSignUpStrings
public final class AccountSignUpReactor: Reactor {
    public var initialState: State
    private var accountRepository: AccountImpl
    
    public enum Action {
        case setNickname(String)
        
        case setYear(Int)
        case setMonth(Int)
        case setDay(Int)
        
        case dateViewDidLoad
        case profileViewDidLoad
    }
    
    public enum Mutation {
        case setNickname(String)
        
        case dateViewDescValue
        
        case setYearValue(Int)
        case setMonthValue(Int)
        case setDayValue(Int)
        
        case buttonTitleValue
    }
    
    public struct State {
        var nickname: String = ""
        var isValidNickname: Bool = false
        
        var dateDesc: String? = ""
        var year: Int?
        var isValidYear: Bool = false
        var month: Int?
        var isValidMonth: Bool = false
        var day: Int?
        var isValidDay: Bool = false
        
        var buttonTitle: String? = ""
    }
    
    init(accountRepository: AccountRepository) {
        self.accountRepository = accountRepository
        self.initialState = State(nickname: "", isValidNickname: false)
    }
}

extension AccountSignUpReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setNickname(let nickname):
            Observable.just(Mutation.setNickname(nickname))
        case .dateViewDidLoad:
            Observable.just(Mutation.dateViewDescValue)
        case .setYear(let year):
            Observable.just(Mutation.setYearValue(year))
        case .setMonth(let month):
            Observable.just(Mutation.setMonthValue(month))
        case .setDay(let day):
            Observable.just(Mutation.setDayValue(day))
        case .profileViewDidLoad:
            Observable.just(Mutation.buttonTitleValue)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setNickname(let nickname):
            newState.nickname = nickname
            newState.isValidNickname = nickname.count <= 10
        case .dateViewDescValue:
            newState.dateDesc = _Str.Date.desc
        case .setYearValue(let year):
            newState.year = year
            newState.isValidYear = year < 2023
        case .setMonthValue(let month):
            newState.month = month
            newState.isValidYear = month < 13
        case .setDayValue(let day):
            newState.day = day
            newState.isValidDay = day < 31
        case .buttonTitleValue:
            newState.buttonTitle = _Str.Profile.buttonTitle
        }
        return newState
    }
}

