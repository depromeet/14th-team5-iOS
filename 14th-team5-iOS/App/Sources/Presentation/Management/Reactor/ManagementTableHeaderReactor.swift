//
//  ManagementTableHeaderViewReactor.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import Core
import MacrosInterface

import ReactorKit

@Reactor
public final class ManagementTableHeaderReactor {
    
    // MARK: - Action
    
    public enum Action { }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setFamilyName(String)
        case setMemberCount(Int)
    }
    
    
    // MARK: - State
    
    public struct State {
        var familyName: String = "나의 가족"
        var memberCount: String = "0"
    }
    
    // MARK: - Properties
    
    @Injected var provider: ServiceProviderProtocol
    
    public var initialState: State
    
    
    // MARK: - Intializer
    
    public init() {
        self.initialState = State()
    }
    
    
    // MARK: - Transform
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.managementService.event
            .flatMap { event in
                switch event {
                case let .setTableHeaderInfo(familyName, memberCount):
                    return Observable<Mutation>.concat(
                        Observable<Mutation>.just(.setFamilyName(familyName)),
                        Observable<Mutation>.just(.setMemberCount(memberCount))
                    )
                    
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(eventMutation, mutation)
    }
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setFamilyName(name):
            newState.familyName = name
            
        case let .setMemberCount(count):
            newState.memberCount = String(count)
        }
        
        return newState
    }
    
    
}
