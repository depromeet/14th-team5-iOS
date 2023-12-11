//
//  CalendarViewReactor.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import UIKit

import Core
import ReactorKit
import RxSwift

final class CalendarViewReactor: Reactor {
    // MARK: - Action
    enum Action { }
    
    // MARK: - Mutation
    enum Mutation { 
        case pushCalendarFeedVC(Date)
        case presentPopoverVC(UIView)
    }
    
    // MARK: - State
    struct State { 
        @Pulse var pushCalendarFeedVC: Date?
        @Pulse var presentPopoverVC: UIView?
    }
    
    // MARK: - Properties
    var initialState: State
    let provider: GlobalStateProviderType
    
    // MARK: - Intializer
    init(provider: GlobalStateProviderType) {
        self.initialState = State()
        self.provider = provider
    }
    
    // MARK: - Transform
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.calendarGlabalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .didSelectCell(date):
                    return Observable<Mutation>.just(.pushCalendarFeedVC(date))
                case let .didTapInfoButton(sourceView):
                    return Observable<Mutation>.just(.presentPopoverVC(sourceView))
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }

    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        return Observable<Mutation>.empty()
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .pushCalendarFeedVC(date):
            newState.pushCalendarFeedVC = date
        case let .presentPopoverVC(sourceView):
            newState.presentPopoverVC = sourceView
        }
        return newState
    }
}

extension CalendarViewReactor {
    func makeCalenderPageCellReactor() -> CalendarPageCellReactor {
        return CalendarPageCellReactor(provider: provider)
    }
}
