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
    
    @Navigator var navigator: NotificationNavigatorProtocol
    @Injected var fetchNotificationUseCase: FetchNotificationUseCaseProtocol
}

extension NotificationReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchNotifications:
            return fetchNotificationUseCase.execute()
                .flatMap { result -> Observable<Mutation> in
                    let items = result.map {
                        NotificationCellReactor(
                            notification: $0
                        )
                    }
                    return .just(.setNotificationDataSource(items))
                }
        case let .didTapNotificationCell(item):
            return Observable.empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case let .setNotificationDataSource(items):
            let dataSource = NotificationSectionModel(model: (), items: items)
            newState.notificationDataSource = [dataSource]
        }
        
        return newState
    }
}
