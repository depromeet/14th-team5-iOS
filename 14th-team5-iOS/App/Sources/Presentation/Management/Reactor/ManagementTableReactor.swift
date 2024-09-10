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
    
    public enum Mutation {
        case setHiddenTableProgresssHud(Bool)
        case setHiddenFetchFailureView(Bool)
    }
    
    
    // MARK: - State
    
    public struct State {
        var hiddenTableProgressHud: Bool = false
        var hiddenFetchFailureView: Bool = true
    }
    
    
    // MARK: - Prperties
    
    public let initialState: State
    
    @Injected var provider: ServiceProviderProtocol
    
    
    // MARK: - Intializer
    
    public init() {
        self.initialState = State()
    }
    
    
    // MARK: - Transform
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.managementService.event
            .flatMap { event in
                switch event {
                case let .hiddenTableProgressHud(hidden):
                    return Observable<Mutation>.just(.setHiddenTableProgresssHud(hidden))
                    
                case let .hiddenMemberFetchFailureView(hidden):
                    return Observable<Mutation>.just(.setHiddenFetchFailureView(hidden))
                    
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(eventMutation, mutation)
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setHiddenTableProgresssHud(hidden):
            newState.hiddenTableProgressHud = hidden
            
        case let .setHiddenFetchFailureView(hidden):
            newState.hiddenFetchFailureView = hidden
        }
        
        return newState
    }
    
}
