//
//  FamilyNameSettingViewReactor.swift
//  App
//
//  Created by Kim dohyun on 7/23/24.
//

import Foundation

import Core
import Util
import Domain
import ReactorKit

public final class FamilyNameSettingViewReactor: Reactor {
    public var initialState: State
    @Injected private var fetchFamilyGroupInfoUseCase: any FetchFamilyGroupInfoUseCaseProtocol
    @Injected private var updateFamilyNameUseCase: any UpdateFamilyNameUseCaseProtocol
    @Injected private var fetchFamilyEditerUseCase: any FetchMembersProfileUseCaseProtocol
    
    @Injected private var provider: any ServiceProviderProtocol
    
    public enum FamilyNameUpdateType {
        case initial
        case update
    }
    
    public enum Action {
        case viewDidLoad
        case didChangeFamilyGroupNickname(String)
        case didTapUpdateFamilyGroupNickname(FamilyNameUpdateType)
    }
    
    public enum Mutation {
        case setFamilyGroupNameEditerItem(MembersProfileEntity)
        case setFamilyGroupInfoItem(FamilyGroupInfoEntity)
        case setFamilyGroupNickName(String)
        case setFamilyNickNameVaildation(Bool)
        case setFamilyGroupEditValidation(Bool)
        case setFamilyNickNameMaximumValidation(Bool)
        case setUpdateFamilyNameItem(FamilyNameEntity)
    }
    
    public struct State {
        @Pulse var familyNameEntity: FamilyNameEntity?
        @Pulse var familyNameEditorEntity: MembersProfileEntity?
        @Pulse var familyGroupInfoEntity: FamilyGroupInfoEntity?
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
            isNickNameMaximumValidation: true
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            
            return fetchFamilyGroupInfoUseCase
                .execute()
                .asObservable()
                .compactMap { $0 }
                .withUnretained(self)
                .flatMap { owner, familyGroupInfo -> Observable<Mutation> in
                    if familyGroupInfo.familyNameEditorId == nil {
                        return .concat(
                            .just(.setFamilyNickNameVaildation(false)),
                            .just(.setFamilyGroupEditValidation(true)),
                            .just(.setFamilyGroupInfoItem(familyGroupInfo))
                        )
                    }
                    let editorId = familyGroupInfo.familyNameEditorId ?? ""
                    return owner.fetchFamilyEditerUseCase.execute(memberId: editorId)
                        .asObservable()
                        .compactMap { $0 }
                        .flatMap { editorInfo -> Observable<Mutation> in
                            return .concat(
                                .just(.setFamilyGroupNameEditerItem(editorInfo)),
                                .just(.setFamilyGroupEditValidation(false))
                            )
                        }
                    
                }
        case let .didChangeFamilyGroupNickname(familyGroupNickName):
            let isValidation = familyGroupNickName.count > 0 && familyGroupNickName.count < 10 ? true : false
            let isMaximumValidation = familyGroupNickName.count < 10 ? true : false
            
            return .concat(
                .just(.setFamilyGroupNickName(familyGroupNickName)),
                .just(.setFamilyNickNameVaildation(isValidation)),
                .just(.setFamilyNickNameMaximumValidation(isMaximumValidation))
            )
        case let .didTapUpdateFamilyGroupNickname(type):
            let familyName = type == .initial ? nil : currentState.familyGroupNickName
            let updateFamilyBody = UpdateFamilyNameRequest(familyName: familyName)
            BBLogManager.analytics(logType: BBEventAnalyticsLog.clickFamilyButton(entry: .familyNameSetting))
            return updateFamilyNameUseCase.execute(body: updateFamilyBody)
                .asObservable()
                .compactMap { $0 }
                .withUnretained(self)
                .do(onNext: { $0.0.provider.managementService.didUpdateFamilyInfo() })
                .flatMap { owner, familyGroupNameEntity -> Observable<Mutation> in
                    return .just(.setUpdateFamilyNameItem(familyGroupNameEntity))
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
        case let .setFamilyGroupInfoItem(familyGroupInfoEntity):
            newState.familyGroupInfoEntity = familyGroupInfoEntity
        }
        return newState
    }
    
}
