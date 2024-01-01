//
//  AccountResignViewReactor.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation

import Domain
import ReactorKit
import RxSwift

final class AccountResignViewReactor: Reactor {
    private let resignUseCase: AccountResignUseCaseProtocol
    var initialState: State
    
    enum Action {
        case viewDidLoad
        case didTapCheckButton(Bool)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSelect(Bool)
    }
    
    struct State {
        var isLoading: Bool
        var isSeleced: Bool
    }
    
    init(resignUseCase: AccountResignUseCaseProtocol) {
        self.resignUseCase = resignUseCase
        self.initialState = State(isLoading: false, isSeleced: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(true)),
                .just(.setLoading(false))
            )
            
        case let .didTapCheckButton(isSelected):
            return .just(.setSelect(isSelected))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setSelect(isSelected):
            newState.isSeleced = isSelected
        }
        
        return newState
    }
    
}
