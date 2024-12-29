//
//  JoinFamilyReactor.swift
//  App
//
//  Created by 마경미 on 12.01.24.
//

import Core
import Domain
import Foundation
import Util

import ReactorKit

public final class JoinFamilyReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case makeFamily
        case joinFamily
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case setShowHome(Bool)
        case setShowJoinFamily(Bool)
    }
    
    // MARK: - State
    public struct State {
        var isShowHome: Bool = false
        var isShowJoinFamily: Bool = false
        var showToastMessage: String = ""
    }
    
    // MARK: - Properties
    public let initialState: State
    @Injected var familyUseCase: FamilyUseCaseProtocol
    
    init() {
        self.initialState = State()
    }
}

extension JoinFamilyReactor {
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .makeFamily:
            return familyUseCase.executeCreateFamily()
                .flatMap {
                    guard let familyResponse: CreateFamilyEntity = $0 else {
                        return Observable.just(Mutation.setShowHome(false))
                    }
                    // Repository에서 이미 UserDefaults에 데이터를 저장하고 있음
                    App.Repository.member.familyCreatedAt.accept(familyResponse.createdAt)
                    App.Repository.member.familyId.accept(familyResponse.familyId)
                    return Observable.just(Mutation.setShowHome(true))
                }
        case .joinFamily:
            MPEvent.Account.invitedGroup.track(with: nil)
            return Observable.just(Mutation.setShowJoinFamily(true))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setShowHome(isShow):
            newState.isShowHome = isShow
        case let .setShowJoinFamily(isShow):
            newState.isShowJoinFamily = isShow
        }
        return newState
    }
}
