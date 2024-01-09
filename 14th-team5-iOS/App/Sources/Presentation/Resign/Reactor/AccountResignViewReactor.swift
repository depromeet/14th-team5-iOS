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
    private let resignUseCase: AccountResignUseCaseProtocol
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
    
    init(resignUseCase: AccountResignUseCaseProtocol) {
        self.resignUseCase = resignUseCase
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
            //TODO: MemberID는 유저 디폴트 저장한거 사용 하자
            return resignUseCase.executeAccountResign(memberId: App.Repository.member.memberID.value ?? "")
                .asObservable()
                .withUnretained(self)
                .flatMap { owner, entity -> Observable<AccountResignViewReactor.Mutation> in
                    if entity.isSuccess {
                        return owner.resignUseCase.executeAccountFcmResign(fcmToken: App.Repository.token.fcmToken.value)
                            .flatMap { fcmEntity ->
                                Observable<AccountResignViewReactor.Mutation> in
                                return .concat(
                                    .just(.setLoading(true)),
                                    .just(.setResignEntity(entity.isSuccess)),
                                    .just(.setLoading(false))
                                )
                            }
                    } else {
                        return .empty()
                    }
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
