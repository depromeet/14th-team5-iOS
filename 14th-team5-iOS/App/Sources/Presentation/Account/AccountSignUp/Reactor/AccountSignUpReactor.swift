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
        case nicknameButtonTapped
        
        case dateViewDidLoad
        case setYear(Int)
        case setMonth(Int)
        case setDay(Int)
        
        case profileViewDidLoad
        
        case signUpStarted
    }
    
    public enum Mutation {
        case setNickname(String)
        case nicknameButtonTapped
        
        case dateViewDescValue
        
        case setYearValue(Int)
        case setMonthValue(Int)
        case setDayValue(Int)
        
        case buttonTitleValue
        case signUpValue
    }
    
    public struct State {
        var nickname: String = ""
        var isValidNickname: Bool = false
        var isValidButton: Bool = false
        var nicknameButtonTappedFinish: Bool = false
        
        var dateDesc: String = ""
        var year: Int?
        var isValidYear: Bool = false
        var month: Int?
        var isValidMonth: Bool = false
        var day: Int?
        var isValidDay: Bool = false
        
        var buttonTitle: String? = ""
        
        var buttonAbled: Bool = false
    }
    
    init(accountRepository: AccountRepository) {
        self.accountRepository = accountRepository
        self.initialState = State()
    }
}

extension AccountSignUpReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        
        // MARK: Nickname
        case .setNickname(let nickname):
            return Observable.just(Mutation.setNickname(nickname))
        case .nicknameButtonTapped:
            return Observable.just(Mutation.nicknameButtonTapped)
            
            
        // MARK: Date
        case .dateViewDidLoad:
            return Observable.just(Mutation.dateViewDescValue)
        case .setYear(let year):
            return Observable.just(Mutation.setYearValue(year))
        case .setMonth(let month):
            return Observable.just(Mutation.setMonthValue(month))
        case .setDay(let day):
            return Observable.just(Mutation.setDayValue(day))
            
        // MARK: Profile
        case .profileViewDidLoad:
            return Observable.just(Mutation.buttonTitleValue)
        case .signUpStarted:
            return accountRepository.signUp(name: currentState.nickname, date: "", photoURL: nil).flatMap { Observable.just(Mutation.signUpValue) }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setNickname(let nickname):
            newState.nickname = nickname
            newState.isValidNickname = nickname.count <= 10
            newState.isValidButton = nickname.count > 2
        case .nicknameButtonTapped:
            newState.nicknameButtonTappedFinish = true
            
        case .dateViewDescValue:
            newState.dateDesc = _Str.Date.desc
        case .setYearValue(let year):
            newState.year = year
            newState.isValidYear = year < 2023
        case .setMonthValue(let month):
            newState.month = month
            newState.isValidMonth = month < 13
        case .setDayValue(let day):
            newState.day = day
            newState.isValidDay = day < 31
        case .buttonTitleValue:
            newState.buttonTitle = _Str.Profile.buttonTitle
        case .signUpValue:
             print("123123")
        
        }
        return newState
    }
}

