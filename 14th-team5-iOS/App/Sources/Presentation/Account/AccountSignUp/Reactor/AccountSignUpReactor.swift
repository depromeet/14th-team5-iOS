//
//  AccountSignUpReactor.swift
//  App
//
//  Created by geonhui Yu on 12/8/23.
//

import Foundation
import Data
import Domain
import Core
import SwiftKeychainWrapper

import ReactorKit

fileprivate typealias _Str = AccountSignUpStrings
public final class AccountSignUpReactor: Reactor {
    public var initialState: State
    private var accountRepository: AccountImpl
    private let memberId: String
    
    public enum Action {
        case setNickname(String)
        case nicknameButtonTapped
        
        case setYear(Int)
        case setMonth(Int)
        case setDay(Int)
        case dateButtonTapped
        case didTapNickNameButton(String)
        
        case profileImageTapped
        case profilePresignedURL(String)
    }
    
    public enum Mutation {
        case setNickname(String)
        case nicknameButtonTapped
        
        case setYearValue(Int)
        case setMonthValue(Int)
        case setDayValue(Int)
        case dateButtonTapped
        case setEditNickName(AccountNickNameEditResponse?)
        
        case profileImageTapped
        case profileButtonTapped(AccessToken?)
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
        var month: Int = 0
        var isValidMonth: Bool = false
        var day: Int = 0
        var isValidDay: Bool = false
        var isValidDateButton: Bool = false
        var dateButtonTappedFinish: Bool = false
        
        var profileImageButtontapped: Bool = false
        var profileButtonTappedFinish: AccessToken? = nil
    }
    
    init(accountRepository: AccountRepository, memberId: String = "") {
        self.accountRepository = accountRepository
        self.memberId = memberId
        self.initialState = State(memberId: memberId)
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
        case .profileImageTapped:
            return Observable.just(Mutation.profileImageTapped)
        case let .profilePresignedURL(presignedURL):
            let date = getDateToString(year: currentState.year!, month: currentState.month, day: currentState.day)
            return accountRepository.signUp(name: currentState.nickname, date: date, photoURL: presignedURL)
                .flatMap { tokenEntity -> Observable<Mutation> in
                    return Observable.just(Mutation.profileButtonTapped(tokenEntity))
                }
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
        case .profileImageTapped:
            newState.profileImageButtontapped = true
        case .profileButtonTapped(let token):
            if let token = token {
                App.Repository.token.accessToken.accept(token.accessToken ?? "")
                App.Repository.token.refreshToken.accept(token.refreshToken ?? "")
                newState.profileButtonTappedFinish = token
            }
        case let .setEditNickName(entity):
            newState.profileNickNameEditEntity = entity
        }
        
        newState.isValidDateButton = newState.isValidYear && newState.isValidMonth && newState.isValidDay
        return newState
    }
}

extension AccountSignUpReactor {
    func getDateToString(year: Int, month: Int, day: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        let date = Calendar.current.date(from: components) ?? Date()
        return dateFormatter.string(from: date)
    }
}
