//
//  AccountSignInReactor.swift
//  App
//
//  Created by geonhui Yu on 12/18/23.
//

import UIKit
import Core
import Data
import Domain

import ReactorKit

public final class AccountSignInReactor: Reactor {
    public var initialState: State
    private var accountRepository: AccountImpl
    
    public enum Action {
        case kakaoLoginTapped(SNS, UIViewController)
        case appleLoginTapped(SNS, UIViewController)
    }
    
    public enum Mutation {
        case kakaoLogin
        case appleLogin
    }
    
    public struct State {
        var pushAccountSingUpVC: Bool
    }
    
    init(accountRepository: AccountRepository) {
        self.accountRepository = accountRepository
        self.initialState = State(pushAccountSingUpVC: false)
    }
}

extension AccountSignInReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .kakaoLoginTapped(let sns, let vc):
            accountRepository.kakaoLogin(with: sns, vc: vc)
                .flatMap { Observable.just(Mutation.kakaoLogin) }
        case .appleLoginTapped(let sns, let vc):
            accountRepository.appleLogin(with: sns, vc: vc)
                .flatMap { Observable.just(Mutation.appleLogin) }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .kakaoLogin:
            newState.pushAccountSingUpVC = true
        case .appleLogin:
            newState.pushAccountSingUpVC = true
        }
        return newState
    }
}
