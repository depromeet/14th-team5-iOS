//
//  MemoriesCalendarPostHeaderReactor.swift
//  App
//
//  Created by 김건우 on 10/17/24.
//

import Core
import Domain
import Foundation

import ReactorKit

final public class MemoriesCalendarPostHeaderReactor: Reactor {
    
    public typealias Action = NoAction
    
    // MARK: - Mutate
    
    public enum Mutation { }
    
    // MARK: - State
    
    public struct State {
        var memberName: String?
        var profileImageUrl: URL?
    }
    
    // MARK: - Properties
    
    public let initialState: State
    
    // MARK: - Intializer
    
    public init() { self.initialState = State() }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
    
}
