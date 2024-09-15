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
        case setEnableConfirmButton(Bool)
        case setEnableTextField(Bool)
    }
    
    
    // MARK: - State
    
    public struct State { 
        @Pulse var inputText: String? = nil
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
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .inputText(text):
            // TODO: - 댓글 내용 임시 저장 코드 구현하기
            let enable = text.count == 0 ? false : true
            return Observable<Mutation>.just(.setEnableConfirmButton(enable))
        }
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setEnableConfirmButton(enable):
            newState.enableConfirmButton = enable
            
        case let .setEnableTextField(enable):
            newState.enableTextField = enable
        }
        
        return newState
    }
    
}
