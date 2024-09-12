//
//  CommentTextFieldReactor.swift
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
public final class CommentTextFieldReactor {
    
    // MARK: - Action
    
    public enum Action { 
        case inputText(String)
    }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setIsEnableConfirmButton(Bool)
        case setIsEnableTextField(Bool)
    }
    
    
    // MARK: - State
    
    public struct State { 
        var enableTextField: Bool = true
        var enableConfirmButton: Bool = false
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
                case let .enableCommentTextField(enable):
                    return Observable<Mutation>.just(.setIsEnableTextField(enable))
                    
                case let .enableConfirmButton(enable):
                    return Observable<Mutation>.just(.setIsEnableConfirmButton(enable))
                    
                @unknown default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .inputText(text):
            let enable = text.count == 0 ? false : true
            return Observable<Mutation>.just(.setIsEnableConfirmButton(enable))
        }
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setIsEnableConfirmButton(enable):
            newState.enableConfirmButton = enable
            
        case let .setIsEnableTextField(enable):
            newState.enableTextField = enable
        }
        
        return newState
    }
    
}
