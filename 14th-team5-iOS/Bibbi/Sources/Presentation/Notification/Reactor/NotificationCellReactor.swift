//
//  NotificationCellReactor.swift
//  App
//
//  Created by 마경미 on 12.01.25.
//

import Core
import Domain

import ReactorKit

final class NotificationCellReactor: Reactor {
    enum Action {
        case setCell
    }
    
    enum Mutation {
        case setProfile(BBProfileImage.Configure)
    }
    
    struct State {
        var notification: NotificationEntity
        
        var profile: BBProfileImage.Configure
    }
    
    var initialState: State
    
    init(notification: NotificationEntity) {
        self.initialState = .init(
            notification: notification,
            profile: .init(
                isBirthday: false,
                imageURL: notification.senderImageUrl,
                name: "TEST"
            )
        )
    }
}

extension NotificationCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .setCell:
            return .just(
                .setProfile(
                    .init(
                        isBirthday: false,
                        imageURL: currentState.notification.senderImageUrl,
                        name: "TEST"
                    )
                )
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        case let .setProfile(profile):
            newState.profile = profile
        }
        
        return newState
    }
}
