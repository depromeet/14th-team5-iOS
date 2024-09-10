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
    @Injected var fetchIsFirstOnboardingUseCase: any FetchIsFirstOnboardingUseCaseProtocol
    private var accountRepository: AccountImpl = AccountRepository()
    private let fcmUseCase: FCMUseCaseProtocol = FCMUseCase(FCMRepository: MeAPIs.Worker())
    private let disposeBag = DisposeBag()
    
    public enum Action {
        case kakaoLoginTapped(SNS, UIViewController)
        case appleLoginTapped(SNS, UIViewController)
    }
    
    public enum Mutation {
        case kakaoLogin(Bool)
        case appleLogin(Bool)
        case setIsFirstOnboarding(Bool)
        
    }
    
    public struct State {
        var pushAccountSingUpVC: Bool
        @Pulse var isFirstOnboarding: Bool
    }
    
    init(/*accountRepository: AccountRepository, fcmUseCase: FCMUseCaseProtocol*/) {
//        self.accountRepository = accountRepository
//        self.fcmUseCase = fcmUseCase
        self.initialState = State(
            pushAccountSingUpVC: false,
            isFirstOnboarding: false
        )
    }
}

extension AccountSignInReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        let isFirstOnboarding = self.fetchIsFirstOnboardingUseCase.execute()
        switch action {
        case .kakaoLoginTapped(let sns, let vc):
            return accountRepository.kakaoLogin(with: sns, vc: vc)
                .flatMap { result -> Observable<Mutation> in
                    switch result {
                    case .success:
                        self.saveFCM()
                        return .concat(
                            .just(.kakaoLogin(true)),
                            .just(.setIsFirstOnboarding(isFirstOnboarding))
                        )
                    case .failed:
                        return .concat(
                            .just(.kakaoLogin(false)),
                            .just(.setIsFirstOnboarding(false))
                        )
                    }
                }
            
            
        case .appleLoginTapped(let sns, let vc):
            return accountRepository.appleLogin(with: sns, vc: vc)
                .flatMap { result -> Observable<Mutation> in
                    switch result {
                    case .success:
                        self.saveFCM()
                        return .concat(
                            .just(.appleLogin(true)),
                            .just(.setIsFirstOnboarding(isFirstOnboarding))
                        )
                    case .failed:
                        return .concat(
                            .just(.appleLogin(false)),
                            .just(.setIsFirstOnboarding(false))
                        )
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
        case let .setIsFirstOnboarding(isFirstOnboarding):
            newState.isFirstOnboarding = isFirstOnboarding
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
