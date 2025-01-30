//
//  NotifiactionReactor.swift
//  App
//
//  Created by 마경미 on 04.01.25.
//

import Foundation

import ReactorKit

final class NotificationReactor: Reactor {
    enum Action {
        case fetchNotifications
        case didTapNotificationCell(IndexPath)
    }
    
    enum Mutation {
        case setNotificationDataSource([NotificationCellReactor])
    }
    
    struct State {
        @Pulse var notificationDataSource: [NotificationSectionModel] = [.init(
            model: (),
            items: []
        )]
    }
    
    var initialState: State = .init()
}
