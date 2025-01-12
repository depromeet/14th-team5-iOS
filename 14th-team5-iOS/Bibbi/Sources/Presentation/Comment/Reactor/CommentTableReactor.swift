//
//  CommentTableReactor.swift
//  App
//
//  Created by 김건우 on 9/12/24.
//

import Core
import MacrosInterface

import ReactorKit

@Reactor
public final class CommentTableReactor {
    
    // MARK: - Action
    
    public enum Action { }
    
    
    // MARK: - Mutation
    
    public enum Mutation { }
    
    
    // MARK: - State
    
    public struct State { }
    
    
    // MARK: - Properties
    
    public let initialState: State
    
    
    // MARK: - Intializer
    
    public init() {
        self.initialState = State()
    }
    
}

