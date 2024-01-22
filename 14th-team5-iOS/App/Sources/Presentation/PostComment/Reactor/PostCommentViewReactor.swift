//
//  PostCommentReactor.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import Foundation

import ReactorKit
import RxSwift

final public class PostCommentViewReactor: Reactor {
    // MARK: - Action
    public enum Action { }
    
    // MARK: - Mutation
    public enum Mutation { }
    
    // MARK: - State
    public struct State {
        var commentCount: Int
    }
    
    // MARK: - Properties
    public var initialState: State
    
    public var provider: GlobalStateProviderProtocol
    
    // MARK: - Intializer
    public init(commentCount: Int, provider: GlobalStateProviderProtocol) {
        self.initialState = State(
            commentCount: commentCount
        )
        
        self.provider = provider
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
