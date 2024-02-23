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
import FirebaseMessaging

public final class AccountSignInReactor: Reactor {
    public var initialState: State
    private var accountRepository: AccountImpl
    private let fcmUseCase: FCMUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    public enum Action {
        case kakaoLoginTapped(SNS, UIViewController)
        case appleLoginTapped(SNS, UIViewController)
    }
    
    public enum Mutation {
        case kakaoLogin(Bool)
        case appleLogin(Bool)
    }
    
    public struct State {
        var pushAccountSingUpVC: Bool
    }
    
    init(accountRepository: AccountRepository, fcmUseCase: FCMUseCaseProtocol) {
        self.accountRepository = accountRepository
        self.fcmUseCase = fcmUseCase
        self.initialState = State(pushAccountSingUpVC: false)
    }
}

extension AccountSignInReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .kakaoLoginTapped(let sns, let vc):
            accountRepository.kakaoLogin(with: sns, vc: vc)
                .flatMap { result in
                    switch result {
                    case .success:
                        self.saveFCM()
                        return Observable.just(Mutation.kakaoLogin(true))
                    case .failed:
                        return Observable.just(Mutation.kakaoLogin(false))
                    }
                }
            
            
        case .appleLoginTapped(let sns, let vc):
            accountRepository.appleLogin(with: sns, vc: vc)
                .flatMap { result -> Observable<Mutation> in
                    switch result {
                    case .success:
                        self.saveFCM()
                        return Observable.just(Mutation.appleLogin(true))
                    case .failed:
                        return Observable.just(Mutation.appleLogin(false))
                    }
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .kakaoLogin(let result):
            newState.pushAccountSingUpVC = result
        case .appleLogin(let result):
            newState.pushAccountSingUpVC = result
        }
        return newState
    }
}

extension AccountSignInReactor {
    private func saveFCM() {
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
              self.fcmUseCase.executeSavingFCMToken(token: .init(fcmToken: token))
                  .asObservable()
                  .bind(onNext: { _ in })
                  .disposed(by: self.disposeBag)
          }
        }
    }
}
