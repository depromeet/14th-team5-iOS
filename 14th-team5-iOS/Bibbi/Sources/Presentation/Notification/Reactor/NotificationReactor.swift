//
//  NotifiactionReactor.swift
//  App
//
//  Created by 마경미 on 04.01.25.
//

import Foundation

import Core
import Domain

import ReactorKit

final class NotificationReactor: Reactor {
    enum Action {
        case fetchNotifications
        case didTapNotificationCell(NotificationCellReactor)
    }
    
    enum Mutation {
        case setNotificationDataSource([NotificationCellReactor]?)
    }
    
    struct State {
        var isShowEmptyCase: Bool?
        @Pulse var notificationDataSource: [NotificationSectionModel]? = nil
    }
    
    var initialState: State = .init()
    
    @Navigator var navigator: NotificationNavigatorProtocol
    @Injected var fetchNotificationUseCase: FetchNotificationUseCaseProtocol
}

extension NotificationReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchNotifications:
            return fetchNotifications()
        case let .didTapNotificationCell(item):
            return didTapNotificationCell(item)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setNotificationDataSource(items):
            if let items,
               !items.isEmpty {
                let dataSource = NotificationSectionModel(model: (), items: items)
                newState.notificationDataSource = [dataSource]
                newState.isShowEmptyCase = false
            } else {
                newState.notificationDataSource = nil
                newState.isShowEmptyCase = true
            }
        }
        
        return newState
    }
}

extension NotificationReactor {
    func fetchNotifications() -> Observable<Mutation> {
        return fetchNotificationUseCase.execute()
            .flatMap { result -> Observable<Mutation> in
                let items = result.map {
                    NotificationCellReactor(
                        notification: $0
                    )
                }
                return .just(.setNotificationDataSource(items))
            }
            .catchAndReturn(.setNotificationDataSource(nil))
    }
    
    func didTapNotificationCell(
        _ item: NotificationCellReactor
    ) -> Observable<Mutation> {
        let noti = item.currentState.notification
        
        guard let link = noti.deepLink else {
            return .empty()
        }
        
        let deepLinkHandler = DeepLinkHandler(urlString: link)
        
        if let deepLink = deepLinkHandler.deepLink as? MainDeepLink,
           let date = noti.createdAt.toDate() {
            if deepLink.type == .openMissionAlert && date < Date() {
                return .empty()
            }
        }
        
        deepLinkHandler.execute()
        return .empty()
    }
}
