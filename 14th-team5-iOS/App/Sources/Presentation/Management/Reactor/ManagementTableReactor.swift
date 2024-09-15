//
//  ManagementTableReactor.swift
//  App
//
//  Created by 김건우 on 9/10/24.
//

import Core
import MacrosInterface

import ReactorKit

@Reactor
final public class ManagementTableReactor {
    
    // MARK: - Action
    
    public enum Action { }
    
    
    // MARK: - Mutation
    
    public enum Mutation { }
    
    
    // MARK: - State
    
    public struct State { }
    
    
    // MARK: - Prperties
    
    public let initialState: State
    
    @Injected var provider: ServiceProviderProtocol
    
    
    // MARK: - Intializer
    
    public init() {
        self.initialState = State()
    }
    
}
