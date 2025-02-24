//
//  NotificationCellReactor.swift
//  App
//
//  Created by 마경미 on 12.01.25.
//

import Core
import DesignSystem
import Domain

import ReactorKit

final class NotificationCellReactor: Reactor {
    enum Action {
        case setCell
    }
    
    enum Mutation {
        case setProfile(BBProfileImage.Configure)
        case setTime(String)
    }
    
    struct State {
        var notification: NotificationEntity
        
        var profile: BBProfileImage.Configure
        var time: String
    }
    
    var initialState: State
    
    init(notification: NotificationEntity) {
        self.initialState = .init(
            notification: notification,
            profile: .init(
                isBirthday: false,
                imageURL: notification.senderImageUrl,
                name: "TEST"
            ),
            time: .init()
        )
    }
}

extension NotificationCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .setCell:
            return .merge([
                Observable<Mutation>.just(
                    .setProfile(makeProfile())
                ),
                Observable<Mutation>.just(.setTime(
                    currentState.notification.createdAt.toDate(
                        with: "yyyy-MM-dd'T'HH:mm:ssZ"
                    ).relativeFormatter())
                )
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        case let .setProfile(profile):
            newState.profile = profile
        case let .setTime(time):
            newState.time = time
        }
        
        return newState
    }
}

extension NotificationCellReactor {
    private func makeProfile() -> BBProfileImage.Configure {
        let profile: BBProfileImage.Configure
        let noti: NotificationEntity = currentState.notification
        switch noti.style {
        case .birthday:
            profile = .init(
                isBirthday: true,
                imageURL: noti.senderImageUrl,
                name: "TEST"
            )
        case .mission:
            profile = .init(image: DesignSystemAsset.bibbiThumbnail.image)
        case .comment:
            profile = .init(
                imageURL: noti.senderImageUrl
            )
        case .update:
            profile = .init(image: DesignSystemAsset.noticeThumbnail.image)
        case .unknown:
            profile = .init(imageURL: nil)
        }
        
        return profile
    }
}
