//
//  OnBoardingReactor.swift
//  App
//
//  Created by geonhui Yu on 12/10/23.
//


import Foundation
import UIKit

import ReactorKit

final class OnBoardingReactor: Reactor {
    
    enum Action {
        case permissionTapped
    }
    
    enum Mutation {
        case setPermissionStatus(Bool)
    }
    
    struct State {
        var isPermissionGranted: Bool?
    }
    
    var initialState: State = State()
}

extension OnBoardingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .permissionTapped:
            return Observable.create { observer in
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
                    if let error = $1 {
                        observer.onError(error)
                    } else {
                        observer.onNext(.setPermissionStatus($0))
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setPermissionStatus(let isPermissionGranted):
            newState.isPermissionGranted = isPermissionGranted
        }
        return newState
    }
}
