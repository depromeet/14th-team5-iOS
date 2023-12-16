//
//  CalendarPageViewCellReactor.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import UIKit

import Core
import ReactorKit
import RxSwift

public final class CalendarPageCellReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case didSelectCell(Date)
        case didTapInfoButton(UIView)
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case none
    }
    
    // MARK: - State
    public struct State { }
    
    // MARK: - Properties
    public var initialState: State
    public let provider: GlobalStateProviderType
    
    // MARK: - Intializer
    init(provider: GlobalStateProviderType) {
        self.initialState = State()
        self.provider = provider
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectCell(date):
            return provider.calendarGlabalState.didSelectCell(date)
                .map { _ in .none }
        case let .didTapInfoButton(sourceView):
            return provider.calendarGlabalState.didTapInfoButton(sourceView)
                .map { _ in .none }
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
