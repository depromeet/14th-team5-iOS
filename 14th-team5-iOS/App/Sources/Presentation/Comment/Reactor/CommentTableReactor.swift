//
//  CommentTableReactor.swift
//  App
//
//  Created by 김건우 on 9/12/24.
//

import Core
import Domain
import Foundation

import ReactorKit
import MacrosInterface

@Reactor
public final class CommentTableReactor {
    
    // MARK: - Action
    
    public enum Action { }
    
    
    // MARK: - Mutation
    
    public enum Mutation { 
        case setHiddenTableProgressHud(Bool)
        case setHiddenFetchFailureView(Bool)
        case setHiddenNoneCommentView(Bool)
//        case setEndRefreshing(Bool)
    }
    
    
    // MARK: - State
    
    public struct State { 
        var hiddenTableProgressHud: Bool = false
        var hiddenFetchFailureView: Bool = true
        var hiddenNoneCommentView: Bool = true
//        @Pulse var isRefreshing: Bool = true
    }
    
    
    // MARK: - Properties
    
    public let initialState: State
    
    @Injected var provider: ServiceProviderProtocol
    
    
    // MARK: - Intializer
    
    public init() {
        self.initialState = State()
    }
    
    // MARK: - Transform
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.commentService.event
            .flatMap { event in
                switch event {
                case let .hiddenCommentFetchFailureView(hidden):
                    return Observable<Mutation>.just(.setHiddenFetchFailureView(hidden))
                    
                case let .hiddenTableProgressHud(hidden):
                    return Observable<Mutation>.just(.setHiddenTableProgressHud(hidden))
                    
                case let .hiddenNoneCommentView(hidden):
                    return Observable<Mutation>.just(.setHiddenNoneCommentView(hidden))
                    
                @unknown default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setHiddenTableProgressHud(isHidden):
            newState.hiddenTableProgressHud = isHidden
            
        case let .setHiddenFetchFailureView(isHidden):
            newState.hiddenFetchFailureView = isHidden
            
        case let .setHiddenNoneCommentView(isHidden):
            newState.hiddenNoneCommentView = isHidden
        }
        
        return newState
    }
    
}

