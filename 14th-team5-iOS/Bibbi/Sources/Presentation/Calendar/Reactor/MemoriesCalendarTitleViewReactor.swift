//
//  MemoriesCalendarTitleViewReactor.swift
//  App
//
//  Created by 김건우 on 10/16/24.
//

import ReactorKit
import MacrosInterface

@Reactor
final public class MemoriesCalendarTitleViewReactor {
    
    // MARK: - Action
    
    public enum Action {
        case didTapTipButton
    }
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setTooltipHidden(hidden: Bool)
    }
    
    // MARK: - State
    
    public struct State {
        @Pulse var hiddenTooltipView: Bool = true
    }
    
    // MARK: - Properties
    
    public var initialState: State = State()
    
    // MARK: - Intializer
    
    public init() {
        self.initialState = State()
    }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapTipButton:
            return Observable<Mutation>.just(.setTooltipHidden(hidden: !currentState.hiddenTooltipView))
        }
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setTooltipHidden(hidden):
            newState.hiddenTooltipView = hidden
        }
        return newState
    }
    
}
