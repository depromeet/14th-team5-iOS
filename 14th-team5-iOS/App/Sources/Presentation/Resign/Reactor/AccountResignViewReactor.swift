//
//  AccountResignViewReactor.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation

import Core
import Domain
import ReactorKit
import RxSwift

final class AccountResignViewReactor: Reactor {
    @Injected var deleteAccountResignUseCase: DeleteAccountResignUseCaseProtocol
    @Injected var updateIsFirstOnboardingUseCase: UpdateIsFirstOnboardingUseCaseProtocol
    var initialState: State
    
    enum Action {
        case viewDidLoad
        case didTapCheckButton(Bool)
        case didTapResignButton
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSelect(Bool)
        case setResignEntity(Bool)
    }
    
    struct State {
        var isLoading: Bool
        var isSeleced: Bool
        var isSuccess: Bool
    }
    
    init() {
        self.initialState = State(
            isLoading: false,
            isSeleced: false,
            isSuccess: false
        )
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
        case .didTapResignButton:
            MPEvent.Account.withdrawl.track(with: nil)
            return deleteAccountResignUseCase.execute()
                .asObservable()
                .compactMap { $0 }
                .withUnretained(self)
                .flatMap { owner, entity -> Observable<Mutation> in
                    if entity.isSuccess {
                        owner.updateIsFirstOnboardingUseCase.execute(nil)
                        return .concat(
                            .just(.setLoading(true)),
                            .just(.setResignEntity(entity.isSuccess)),
                            .just(.setLoading(false))
                        )
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setSelect(isSelected):
            newState.isSeleced = isSelected
        case let .setResignEntity(isSuccess):
            newState.isSuccess = isSuccess
        }
        
        return newState
    }
    
}
