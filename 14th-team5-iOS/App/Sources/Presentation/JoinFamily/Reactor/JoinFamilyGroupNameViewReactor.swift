//
//  JoinFamilyGroupNameViewReactor.swift
//  App
//
//  Created by Kim dohyun on 7/23/24.
//

import Foundation

import Core
import Domain
import ReactorKit

public final class JoinFamilyGroupNameViewReactor: Reactor {
    public var initialState: State
    @Injected private var updateJoinFamilyGroupUseCase: UpdateJoinFamilyGroupNameUseCaseProtocol
    
    public enum Action {
        case didChangeFamilyGroupNickname(String)
        case didTapUpdateFamilyGroupNickname
    }
    
    public enum Mutation {
        case setFamilyGroupNickName(String)
        case setFamilyGroupNickNameResponse(JoinFamilyGroupNameEntity?)
        case setFamilyNickNameVaildation(Bool)
        case setFamilyNickNameMaximumValidation(Bool)
    }
    
    public struct State {
        @Pulse var familyGroupNameEntity: JoinFamilyGroupNameEntity?
        var familyGroupNickName: String
        var isNickNameVaildation: Bool
        var isNickNameMaximumValidation: Bool
    }
    
    
    init() {
        self.initialState = State(
            familyGroupNameEntity: nil,
            familyGroupNickName: "",
            isNickNameVaildation: false,
            isNickNameMaximumValidation: false
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didChangeFamilyGroupNickname(familyGroupNickName):
            let isValidation = familyGroupNickName.count > 0 ? true : false
            let isMaximumValidation = familyGroupNickName.count < 10 ? true : false
            
            return .concat(
                .just(.setFamilyGroupNickName(familyGroupNickName)),
                .just(.setFamilyNickNameVaildation(isValidation)),
                .just(.setFamilyNickNameMaximumValidation(isMaximumValidation))
            )
        case .didTapUpdateFamilyGroupNickname:
            let body = JoinFamilyGroupNameRequest(familyName: currentState.familyGroupNickName)
            return updateJoinFamilyGroupUseCase.execute(body: body)
                .asObservable()
                .flatMap { entity -> Observable<JoinFamilyGroupNameViewReactor.Mutation> in
                    return .just(.setFamilyGroupNickNameResponse(entity))
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setFamilyGroupNickName(familyGroupNickName):
            newState.familyGroupNickName = familyGroupNickName
        case let .setFamilyNickNameVaildation(isNickNameVaildation):
            newState.isNickNameVaildation = isNickNameVaildation
        case let .setFamilyNickNameMaximumValidation(isNickNameMaximumValidation):
            newState.isNickNameMaximumValidation = isNickNameMaximumValidation
        case let .setFamilyGroupNickNameResponse(familyGroupNameEntity):
            newState.familyGroupNameEntity = familyGroupNameEntity
        }
        return newState
    }
    
}
