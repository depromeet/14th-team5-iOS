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
    private let meUseCase: MeUseCaseProtocol = MeUseCase(meRepository: MeAPIs.Worker())
    private let fcmUseCase: FCMUseCaseProtocol = FCMUseCase(FCMRepository: MeAPIs.Worker())
    @Navigator var signInNavigator: AccountSignInNavigatorProtocol
    private let disposeBag = DisposeBag()
    
    public enum Action {
        case kakaoLoginTapped(SNS, UIViewController)
        case appleLoginTapped(SNS, UIViewController)
    }
    
    public enum Mutation {
        case setIsFirstOnboarding(Bool)
    }
    
    public struct State {
        @Pulse var isFirstOnboarding: Bool
    }
    
    init(/*accountRepository: AccountRepository, fcmUseCase: FCMUseCaseProtocol*/) {
//        self.accountRepository = accountRepository
//        self.fcmUseCase = fcmUseCase
        self.initialState = State(
            isFirstOnboarding: false
        )
    }
}

extension AccountSignInReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .kakaoLoginTapped(let sns, let vc):
            return accountRepository.kakaoLogin(with: sns, vc: vc)
                .withUnretained(self)
                .flatMap { owner, result -> Observable<Mutation> in
                    switch result {
                    case .success:
                        owner.saveFCM()
                        return owner.transitionViewController()
                    case .failed:
                        return .empty()
                    }
                }
            
            
        case .appleLoginTapped(let sns, let vc):
            return accountRepository.appleLogin(with: sns, vc: vc)
                .withUnretained(self)
                .flatMap { owner, result -> Observable<Mutation> in
                    switch result {
                    case .success:
                        self.saveFCM()
                        return owner.transitionViewController()
                    case .failed:
                        return .empty()
                    }
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
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


extension AccountSignInReactor {
    private func transitionViewController() -> Observable<Mutation> {
        let isFirstOnboarding = self.fetchIsFirstOnboardingUseCase.execute()
        return App.Repository.token.accessToken
            .skip(1)
            .withUnretained(self)
            .flatMapLatest { owner, token -> Observable<Mutation> in
                guard let token,
                      let isTemporaryToken = token.isTemporaryToken else {
                    return .empty()
                }
                
                if isTemporaryToken {
                    owner.signInNavigator.toSignUp()
                    return .empty()
                }
            
                return owner.meUseCase.getMemberInfo()
                    .asObservable()
                    .flatMap { memberInfo -> Observable<Mutation> in
                        if isFirstOnboarding {
                            if memberInfo?.familyId == nil {
                                owner.signInNavigator.toJoinFamily()
                                return .empty()
                            }
                            owner.signInNavigator.toMain()
                            return .empty()
                        }
                        owner.signInNavigator.toOnboarding()
                        return .empty()
                    }
            }
    }
    
}
