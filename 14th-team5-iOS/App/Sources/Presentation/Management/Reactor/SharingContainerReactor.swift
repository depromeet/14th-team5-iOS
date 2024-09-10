//
//  InvitationUrlContainerViewReactor.swift
//  App
//
//  Created by 김건우 on 1/16/24.
//

import Core
import Foundation

import ReactorKit
import RxSwift

final public class SharingContainerReactor: Reactor {
    
    // MARK: - Action
    
    public enum Action { }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setProgressHud(Bool)
    }
    
    
    // MARK: - State
    
    public struct State {
        var hiddenProgresHud: Bool = true
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var provider: ServiceProviderProtocol
    
    
    // MARK: - Intializer
    
    public init() {
        self.initialState = State()
    }
    
    
    // MARK: - Transform
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.managementService.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .hiddenSharingProgressHud(hidden):
                    return Observable<Mutation>.just(.setProgressHud(hidden))
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setProgressHud(hidden):
            newState.hiddenProgresHud = hidden
        }
        return newState
    }
}
