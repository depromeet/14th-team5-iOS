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

final class AccountSignInReactor: Reactor {
    
    public var initialState: State
//    private var accountRepository: AccountImpl
    
    enum Action {
        case kakaoLoginTapped(SNS, UIViewController)
    }
    
    enum Mutation {
        case kakaoLogin
    }
    
    struct State {
        var acceessToken: String
    }
    
    init() {
//        self.accountRepository = accountRepository
        self.initialState = State(acceessToken: "")
    }
}

extension AccountSignInReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .kakaoLoginTapped(let sns, let vc):
            Observable.just(Mutation.kakaoLogin)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .kakaoLogin:
            App.Repository.token.accessToken.accept(state.acceessToken)
        }
        return newState
    }
}
