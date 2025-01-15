//
//  OnBoardingReactor.swift
//  App
//
//  Created by geonhui Yu on 12/10/23.
//


import UIKit

import Core
import Data
import Domain
import Util

import ReactorKit

public final class OnBoardingReactor: Reactor {
    
    public var initialState: State = State()
    @Injected var familyUseCase: FamilyUseCaseProtocol
    @Injected var updateIsFirstOnboardingUseCase: any UpdateIsFirstOnboardingUseCaseProtocol
    
    public enum Action {
        case permissionTapped
    }
    
    public enum Mutation {
        case permissionTapped
    }
    
    public struct State {
        var permissionTappedFinish: Bool = false
    }
    
    init() {
        self.initialState = State()
    }
}

extension OnBoardingReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .permissionTapped:
            Observable.create { [weak self] observer in
                self?.updateIsFirstOnboardingUseCase.execute(true)
                MPEvent.Account.invitedGroupFinished.track(with: nil)
                UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .badge, .sound],
                    completionHandler: { granted, error in
                        if granted {
                            MPEvent.Account.allowNotification.track(with: nil)
                        }
                        observer.onNext(granted)
                        observer.onCompleted()
                    }
                )
                return Disposables.create()
            }
            .flatMap { [weak self] (granted: Bool) -> Observable<Mutation> in
                if granted {
                    return Observable.just(.permissionTapped)
                } else {
                    return Observable<Mutation>.empty()
                }
            }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .permissionTapped:
            newState.permissionTappedFinish = true
        }
        return newState
    }
}
