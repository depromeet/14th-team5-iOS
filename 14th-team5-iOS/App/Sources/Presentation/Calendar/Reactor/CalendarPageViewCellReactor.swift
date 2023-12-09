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

final class CalendarPageCellReactor: Reactor {
    // MARK: - Action
    enum Action {
        case didSelectCell(Date)
        case didPressInfoButton(UIView)
    }
    
    // MARK: - Mutation
    enum Mutation { 
        case none
    }
    
    // MARK: - State
    struct State { }
    
    // MARK: - Properties
    var initialState: State
    let provider: GlobalStateProviderType
    
    // MARK: - Intializer
    init(provider: GlobalStateProviderType) {
        self.initialState = State()
        self.provider = provider
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectCell(date):
            return provider.calendarGlabalState.didSelectCell(date)
                .map { _ in .none }
        case let .didPressInfoButton(sourceView):
            return provider.calendarGlabalState.didPressedInfoButton(sourceView)
                .map { _ in .none }
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
