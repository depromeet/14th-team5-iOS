//
//  SplashReactor.swift
//  App
//
//  Created by 김건우 on 1/4/24.
//

import Foundation
import Core

import ReactorKit
import RxSwift

public final class SplashReactor: Reactor {
    // MARK: - Action
    public enum Action { }
    
    // MARK: - Mutation
    public enum Mutation { }
    
    // MARK: - State
    public struct State { }
    
    // MARK: - Properties
    public var initialState: State
    
    // MARK: - Intializer
    public init(initialState: State) {
        self.initialState = initialState
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        return Observable<Mutation>.empty()
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
