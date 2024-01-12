//
//  OnBoardingReactor.swift
//  App
//
//  Created by geonhui Yu on 12/10/23.
//


import Foundation
import UIKit
import Data

import ReactorKit

public final class OnBoardingReactor: Reactor {
    
    public var initialState: State
    private var accountRepository: AccountImpl
    
    public enum Action {
        case permissionTapped
    }
    
    public enum Mutation {
        case permissionTapped
    }
    
    public struct State {
        var permissionTappedFinish: Bool = false
    }
    
    init(accountRepository: AccountRepository) {
        self.accountRepository = accountRepository
        self.initialState = State()
    }
}

extension OnBoardingReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .permissionTapped:
            return Observable.create { observer in
                UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .badge, .sound],
                    completionHandler: { granted, error in
                        observer.onNext(Mutation.permissionTapped)
                        observer.onCompleted()
                    }
                )
                return Disposables.create()
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
