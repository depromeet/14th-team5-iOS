//
//  AccountSignUpReactor.swift
//  App
//
//  Created by geonhui Yu on 12/8/23.
//

import Foundation
import Data
import Domain

import ReactorKit

fileprivate typealias _Str = AccountSignUpStrings
public final class AccountSignUpReactor: Reactor {
    public var initialState: State
    private var accountRepository: AccountImpl
    private let memberId: String
    private let profileType: AccountLoaction
    
    public enum Action {
        case setNickname(String)
        case nicknameButtonTapped
        
        case setYear(Int)
        case setMonth(Int)
        case setDay(Int)
        case dateButtonTapped
        case didTapNickNameButton(String)
        case profileButtonTapped
    }
    
    public enum Mutation {
        case setNickname(String)
        case nicknameButtonTapped
        
        case setYearValue(Int)
        case setMonthValue(Int)
        case setDayValue(Int)
        case dateButtonTapped
        case setEditNickName(AccountNickNameEditResponse?)
        
        case profileButtonTapped
    }
    
    public struct State {
        var nickname: String = ""
        var isValidNickname: Bool = false
        var isValidNicknameButton: Bool = false
        var nicknameButtonTappedFinish: Bool = false
        var memberId: String
        var profileNickNameEditEntity: AccountNickNameEditResponse?
        var year: Int?
        var isValidYear: Bool = false
        var month: Int?
        var isValidMonth: Bool = false
        var day: Int?
        var isValidDay: Bool = false
        var isValidDateButton: Bool = false
        var dateButtonTappedFinish: Bool = false
        var profileType: AccountLoaction = .account
        
        var profileButtonTappedFinish: Bool = false
    }
    
    init(
        accountRepository: AccountRepository,
        memberId: String = "",
        profileType: AccountLoaction = .account
    ) {
        self.accountRepository = accountRepository
        self.memberId = memberId
        self.profileType = profileType
        self.initialState = State(memberId: memberId, profileType: self.profileType)
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
        case .setYear(let year):
            return Observable.just(Mutation.setYearValue(year))
        case .setMonth(let month):
            return Observable.just(Mutation.setMonthValue(month))
        case .setDay(let day):
            return Observable.just(Mutation.setDayValue(day))
        case .dateButtonTapped:
            return Observable.just(Mutation.dateButtonTapped)
            
            // MARK: Profile
        case .profileButtonTapped:
            return accountRepository.signUp(name: currentState.nickname, date: "", photoURL: nil).flatMap { Observable.just(Mutation.profileButtonTapped) }
            
        case let .didTapNickNameButton(nickName):
            let parameters: AccountNickNameEditParameter = AccountNickNameEditParameter(name: nickName)
            return accountRepository.executeNicknameUpdate(memberId: self.currentState.memberId, parameter: parameters)
                .asObservable()
                .flatMap { entity -> Observable<AccountSignUpReactor.Mutation> in
                        .just(.setEditNickName(entity))
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setNickname(let nickname):
            newState.nickname = nickname
            newState.isValidNickname = nickname.count <= 10
            newState.isValidNicknameButton = nickname.count > 2
        case .nicknameButtonTapped:
            newState.nicknameButtonTappedFinish = true
            
        case .setYearValue(let year):
            newState.year = year
            newState.isValidYear = year < 2023
        case .setMonthValue(let month):
            newState.month = month
            newState.isValidMonth = month < 13
        case .setDayValue(let day):
            newState.day = day
            newState.isValidDay = day < 31
        case .dateButtonTapped:
            newState.dateButtonTappedFinish = true
            
            
        case .profileButtonTapped:
            newState.profileButtonTappedFinish = true
            
        case let .setEditNickName(entity):
            newState.profileNickNameEditEntity = entity
        }
        
        newState.isValidDateButton = newState.isValidYear && newState.isValidMonth && newState.isValidDay
        return newState
    }
}

