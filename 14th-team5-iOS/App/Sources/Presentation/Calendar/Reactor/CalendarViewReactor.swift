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

public final class CalendarViewReactor: Reactor {
    // MARK: - Action
    public enum Action { }
    
    // MARK: - Mutation
    public enum Mutation {
        case pushCalendarFeedVC(Date)
        case presentPopoverVC(UIView)
    }
    
    // MARK: - State
    public struct State {
        @Pulse var pushCalendarFeedVC: Date?
        @Pulse var shouldPresentPopoverVC: UIView?
    }
    
    // MARK: - Properties
    public var initialState: State
    public let provider: GlobalStateProviderType
    
    // MARK: - Intializer
    init(provider: GlobalStateProviderType) {
        self.initialState = State()
        self.provider = provider
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
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
    public func mutate(action: Action) -> Observable<Mutation> {
        return Observable<Mutation>.empty()
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .pushCalendarFeedVC(date):
            newState.pushCalendarFeedVC = date
        case let .presentPopoverVC(sourceView):
            newState.shouldPresentPopoverVC = sourceView
        }
        return newState
    }
}
