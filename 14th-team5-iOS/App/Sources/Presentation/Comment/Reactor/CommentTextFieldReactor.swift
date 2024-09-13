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
        case clearTextField
        case setIsEnableConfirmButton(Bool)
        case setIsEnableTextField(Bool)
        case becomFirstResponder
    }
    
    
    // MARK: - State
    
    public struct State { 
        @Pulse var inputText: String? = nil
        var enableTextField: Bool = true
        var enableConfirmButton: Bool = false
        @Pulse var becomeFirstResponder: Bool = false
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
                    
                case .clearCommentTextField:
                    return Observable<Mutation>.just(.clearTextField)
                    
                case .becomeFirstResponder:
                    return Observable<Mutation>.just(.becomFirstResponder)
            
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
            // TODO: - 댓글 내용 임시 저장 코드 구현하기
            let enable = text.count == 0 ? false : true
            return Observable<Mutation>.just(.setIsEnableConfirmButton(enable))
        }
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .clearTextField:
            newState.inputText = nil
            
        case .becomFirstResponder:
            newState.becomeFirstResponder = true
            
        case let .setIsEnableConfirmButton(enable):
            newState.enableConfirmButton = enable
            
        case let .setIsEnableTextField(enable):
            newState.enableTextField = enable
        }
        
        return newState
    }
    
}
