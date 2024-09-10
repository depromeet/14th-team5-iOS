//
//  InvitationUrlContainerViewReactor.swift
//  App
//
//  Created by 김건우 on 1/16/24.
//

import Core
import Foundation

import ReactorKit
import RxSwift

final public class SharingRoundedRectViewReactor: Reactor {
    
    // MARK: - Action
    
    public enum Action { }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setIndicatorView(Bool)
    }
    
    
    // MARK: - State
    
    public struct State {
        var shouldHiddenIndicatorView: Bool
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var provider: GlobalStateProviderProtocol
    
    
    // MARK: - Intializer
    
    public init(provider: GlobalStateProviderProtocol) {
        self.initialState = State(shouldHiddenIndicatorView: false)
        self.provider = provider
    }
    
    
    // MARK: - Transform
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.activityGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .hiddenInvitationUrlIndicatorView(hidden):
                    return Observable<Mutation>.just(.setIndicatorView(hidden))
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setIndicatorView(hidden):
            newState.shouldHiddenIndicatorView = hidden
        }
        return newState
    }
}
