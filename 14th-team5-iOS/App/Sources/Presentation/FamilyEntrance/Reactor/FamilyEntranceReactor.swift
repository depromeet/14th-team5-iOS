//
//  JoinedFamilyReactor.swift
//  App
//
//  Created by geonhui Yu on 2/8/24.
//

import Foundation

import Core
import Domain

import ReactorKit

public final class FamilyEntranceReactor: Reactor {
    public enum Action {
        case loadFamily
        case showHome
        case joinFamily
    }
    
    public enum Mutation {
        case setProfiles([FamilyMemberProfileEntity]?)
    }
    
    public struct State {
        var profiles: [FamilyMemberProfileEntity]?
    }
    
    public var initialState: State = State()
    @Navigator var navigator: FamilyEntranceNavigatorProtocol
    @Injected var provider: ServiceProviderProtocol
    @Injected var familyUseCase: FamilyUseCaseProtocol
}

extension FamilyEntranceReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .showHome:
            navigator.toHome()
            return .empty()
        case .joinFamily:
            UserDefaults.standard.clearInviteCode()
            navigator.toInputCode()
            return .empty()
        case .loadFamily:
            return familyUseCase.executeFetchPaginationFamilyMembers(query: .init())
                .flatMap {
                    return Observable.just(.setProfiles($0?.results))
                }
            
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setProfiles(let profiles):
            newState.profiles = profiles
        }
        return newState
    }
}
