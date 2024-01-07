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
    private let profileType: AccountLoaction
    
    public enum Action {
        case setNickname(String)
        case didTapNicknameNextButton
        case didTapNickNameButton(String)
        
        case setYear(Int)
        case setMonth(Int)
        case setDay(Int)
        case didTapDateNextButton
        
        case profileImageTapped // Action Sheet출력 하는 이벤트
        case didTapCompletehButton
        case profilePresignedURL(String)
    }
    
    public enum Mutation {
        case setNickname(String)
        case didTapNicknameNextButton
        
        case setYearValue(Int)
        case setMonthValue(Int)
        case setDayValue(Int)
        case didTapDateNextButton
        case setEditNickName(AccountNickNameEditResponse?)
        
        case profileImageTapped
        case setprofilePresignedURL(String)
        case didTapCompletehButton(AccessTokenResponse?)
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
        var profileType: AccountLoaction = .account
        
        var profilePresignedURL: String = ""
        var profileImageButtontapped: Bool = false
        var didTapCompletehButtonFinish: AccessTokenResponse? = nil
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
        case .didTapNicknameNextButton:
            return Observable.just(Mutation.didTapNicknameNextButton)
            
            // MARK: Date
        case .setYear(let year):
            return Observable.just(Mutation.setYearValue(year))
        case .setMonth(let month):
            return Observable.just(Mutation.setMonthValue(month))
        case .setDay(let day):
            return Observable.just(Mutation.setDayValue(day))
        case .didTapDateNextButton:
            return Observable.just(Mutation.didTapDateNextButton)
            
            // MARK: Profile
        case .profileImageTapped:
            return Observable.just(Mutation.profileImageTapped)
        
        case let .profilePresignedURL(presignedURL):
            return Observable.just(Mutation.setprofilePresignedURL(presignedURL))
        case let .didTapNickNameButton(nickName):
            let parameters: AccountNickNameEditParameter = AccountNickNameEditParameter(name: nickName)
            return accountRepository.executeNicknameUpdate(memberId: self.currentState.memberId, parameter: parameters)
                .asObservable()
                .flatMap { entity -> Observable<AccountSignUpReactor.Mutation> in
                        .just(.setEditNickName(entity))
                }
            
        case .didTapCompletehButton:
            let date = getDateToString(year: currentState.year!, month: currentState.month, day: currentState.day)
            return accountRepository.signUp(name: currentState.nickname, date: date, photoURL: currentState.profilePresignedURL)
                .flatMap { tokenEntity -> Observable<Mutation> in
                    return Observable.just(Mutation.didTapCompletehButton(tokenEntity))
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
        case .didTapNicknameNextButton:
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
        case .didTapDateNextButton:
            newState.dateButtonTappedFinish = true
        case .setprofilePresignedURL(let url):
            newState.profilePresignedURL = url
        case .profileImageTapped:
            newState.profileImageButtontapped = true
        case .didTapCompletehButton(let token):
            if let token = token {
                
                let accessToken = token.accessToken
                let refreshToken = token.refreshToken
                let isTemporaryToken = token.isTemporaryToken
                
                let tk = AccessToken(accessToken: accessToken, refreshToken: refreshToken, isTemporaryToken: isTemporaryToken)
                App.Repository.token.accessToken.accept(tk)
                newState.didTapCompletehButtonFinish = token
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
