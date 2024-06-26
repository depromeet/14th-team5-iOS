//
//  WebContentViewReactor.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation

import RxSwift
import ReactorKit

public class WebContentReactor: Reactor {
    public var initialState: State
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
    }
    
    public struct State {
        var isLoading: Bool
        var url: URL?
    }
    
    public init(contentURL: URL?) {
        self.initialState = State(
            isLoading: false,
            url: contentURL
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(true)),
                .just(.setLoading(false))
            )
  
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        
        return newState
    }
    
}
