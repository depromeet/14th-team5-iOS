//
//  ManagementTableHeaderViewReactor.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import Core
import MacrosInterface

import ReactorKit

@Reactor
public final class ManagementTableHeaderReactor {
    
    // MARK: - Action
    
    public enum Action {
        case didTappedToolTipButton
    }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setToolTipHidden(Bool)
    }
    
    
    // MARK: - State
    
    public struct State {
        @Pulse var isHidden: Bool = false
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    
    // MARK: - Intializer
    
    public init() {
        self.initialState = State()
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTappedToolTipButton:
            return .just(.setToolTipHidden(!currentState.isHidden))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setToolTipHidden(isHidden):
            newState.isHidden = isHidden
        }
        return newState
    }
}
