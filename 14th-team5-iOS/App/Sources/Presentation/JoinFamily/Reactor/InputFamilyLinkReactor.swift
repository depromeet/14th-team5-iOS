//
//  InputFamilyLinkReactor.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import Foundation

import Domain

import ReactorKit

public final class InputFamilyLinkReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case inputLink(String)
        case tapJoinFamily
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case setLinkString(String)
        case setJoinFamily
    }
    
    // MARK: - State
    public struct State {
        var linkString: String = ""
        var statusJoinFamily: Bool = false
        var showToastMessage: String = ""
    }
    
    // MARK: - Properties
    public let initialState: State
    private let familyUseCase: InviteFamilyViewUseCaseProtocol
    
    init(initialState: State, familyUseCase: InviteFamilyViewUseCaseProtocol) {
        self.initialState = initialState
        self.familyUseCase = familyUseCase
    }
}

extension InputFamilyLinkReactor {
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputLink:
            return Observable.empty()
        case .tapJoinFamily:
            return Observable.empty()
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLinkString(_):
            break
        case .setJoinFamily:
            break
        }
        return newState
    }
}
