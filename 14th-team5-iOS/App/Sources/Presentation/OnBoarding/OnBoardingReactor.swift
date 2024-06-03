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

import ReactorKit

public final class OnBoardingReactor: Reactor {
    
    public var initialState: State = State()
    private var familyUseCase: FamilyUseCaseProtocol
    
    public enum Action {
        case permissionTapped
    }
    
    public enum Mutation {
        case permissionTapped
    }
    
    public struct State {
        var permissionTappedFinish: Bool = false
    }
    
    init(familyUseCase: FamilyUseCaseProtocol) {
        self.familyUseCase = familyUseCase
        self.initialState = State()
    }
}

extension OnBoardingReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .permissionTapped:
            return Observable.zip(
                Observable.create { observer in
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
                },
                familyUseCase.executeFetchPaginationFamilyMembers(query: .init())
            )
            .flatMap { (granted: Bool, _) -> Observable<Mutation> in
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
