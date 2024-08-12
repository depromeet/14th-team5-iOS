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
    @Injected private var memberUseCase: MemberUseCaseProtocol
    @Injected private var updateFamilyNameUseCase: UpdateFamilyNameUseCaseProtocol
    @Injected private var fetchFamilyEditerUseCase: FetchMembersProfileUseCaseProtocol
    
    public enum Action {
        case viewDidLoad
        case didChangeFamilyGroupNickname(String)
        case didTapUpdateFamilyGroupNickname
    }
    
    public enum Mutation {
        case setFamilyGroupNameEditerItem(MembersProfileEntity)
        case setFamilyGroupNickName(String)
        case setFamilyNickNameVaildation(Bool)
        case setFamilyGroupEditValidation(Bool)
        case setFamilyNickNameMaximumValidation(Bool)
        case setUpdateFamilyNameItem(FamilyNameEntity)
    }
    
    public struct State {
        @Pulse var familyNameEntity: FamilyNameEntity?
        @Pulse var familyNameEditorEntity: MembersProfileEntity?
        var familyGroupNickName: String
        var isNickNameVaildation: Bool
        var isEdit: Bool
        var isNickNameMaximumValidation: Bool
    }
    
    init() {
        self.initialState = State(
            familyGroupNickName: "",
            isNickNameVaildation: false,
            isEdit: false,
            isNickNameMaximumValidation: false
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            if memberUseCase.executeFetchFamilyNameEditorId().isEmpty {
                return .just(.setFamilyGroupEditValidation(false))
            } else {
                let editorId = memberUseCase.executeFetchFamilyNameEditorId()
                return fetchFamilyEditerUseCase.execute(memberId: editorId)
                    .asObservable()
                    .compactMap { $0 }
                    .flatMap { entity -> Observable<Mutation> in
                        return .concat(
                            .just(.setFamilyGroupNameEditerItem(entity)),
                            .just(.setFamilyGroupEditValidation(true))
                        )
                    }
            }
        case let .didChangeFamilyGroupNickname(familyGroupNickName):
            let isValidation = familyGroupNickName.count > 0 ? true : false
            let isMaximumValidation = familyGroupNickName.count < 10 ? true : false
            
            return .concat(
                .just(.setFamilyGroupNickName(familyGroupNickName)),
                .just(.setFamilyNickNameVaildation(isValidation)),
                .just(.setFamilyNickNameMaximumValidation(isMaximumValidation))
            )
        case .didTapUpdateFamilyGroupNickname:
            let updateFamilyBody = UpdateFamilyNameRequest(familyName: currentState.familyGroupNickName)
            return updateFamilyNameUseCase.execute(body: updateFamilyBody)
                .asObservable()
                .compactMap { $0 }
                .flatMap { entity -> Observable<Mutation> in
                    print("entity familyGroup : \(entity)")
                    return .just(.setUpdateFamilyNameItem(entity))
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
        case let .setUpdateFamilyNameItem(familyNameEntity):
            newState.familyNameEntity = familyNameEntity
        case let .setFamilyGroupNameEditerItem(familyNameEditorEntity):
            newState.familyNameEditorEntity = familyNameEditorEntity
        case let .setFamilyGroupEditValidation(isEdit):
            newState.isEdit = isEdit
        }
        return newState
    }
    
}
