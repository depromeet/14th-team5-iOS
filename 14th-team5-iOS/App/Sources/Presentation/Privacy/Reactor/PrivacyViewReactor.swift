//
//  PrivacyViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/15/23.
//

import Foundation

import Core
import Domain
import Data
import ReactorKit

public final class PrivacyViewReactor: Reactor {
    public var initialState: State
    @Injected var fetchAppVersionUseCase: FetchAppVersionUseCaseProtocol
    @Injected var signOutUseCase: SignOutUseCaseProtocol
    @Injected var resignFamilyUseCase: ResignFamilyUseCaseProtocol
    @Injected var fetchAuthorizationItemUseCase: FetchAuthorizationItemsUseCaseProtocol
    @Injected var fetchPrivacyItemsUseCase: FetchPrivacyItemsUseCaseProtocol
    private let memberId: String
    
    public enum Action {
        case viewDidLoad
        case didTapLogoutButton
        case didTapFamilyUserResign
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setBibbiAppInfo(AppVersionEntity)
        case setFamilyResign(Bool)
        case setPrivacyItemModel([PrivacyItemModel])
        case setAuthorizationItemModel([PrivacyItemModel])
        case setLogout(Bool)
    }
    
    public struct State {
        var isLoading: Bool
        var isFamilyResign: Bool
        var memberId: String
        var isSuccess: Bool
        @Pulse var appInfo: AppVersionEntity?
        @Pulse var section: [PrivacySectionModel]
        
    }
    
    public init(memberId: String) {
        self.memberId = memberId
        self.initialState = State(
            isLoading: false,
            isFamilyResign: false,
            memberId: memberId,
            isSuccess: false,
            appInfo: nil,
            section: [
                .privacyWithAuth([]),
                .userAuthorization([])
            ]
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            BBLogManager.analytics(logType: BBEventAnalyticsLog.viewPage(pageName: .setting))
            return .concat(
                .just(.setLoading(true)),
                .merge(
                    fetchAppVersionUseCase.execute()
                        .withUnretained(self)
                        .flatMap { owner, appVersionEntity -> Observable<Mutation> in
                            return owner.fetchPrivacyItemsUseCase.execute()
                                .flatMap { privateInfo -> Observable<Mutation> in
                                    var sectionItem: [PrivacyItemModel] = []
                                    privateInfo.forEach {
                                        sectionItem.append(
                                            .privacyWithAuthItem(
                                                PrivacyCellReactor(
                                                    descrption: $0,
                                                    isCheck: appVersionEntity.latest
                                                )
                                            )
                                        )
                                    }
                                    
                                    return .concat(
                                        .just(.setPrivacyItemModel(sectionItem)),
                                        .just(.setBibbiAppInfo(appVersionEntity))
                                    )
                                }
                            
                        },
                    
                    fetchAuthorizationItemUseCase.execute()
                        .asObservable()
                        .flatMap { authorizationInfo -> Observable<Mutation> in
                            var sectionItems: [PrivacyItemModel] = []
                            authorizationInfo.forEach {
                                sectionItems.append(.userAuthorizationItem(PrivacyCellReactor(descrption: $0, isCheck: false)))
                            }
                            
                            return .concat(
                                .just(.setAuthorizationItemModel(sectionItems)),
                                .just(.setLoading(false))
                            )
                        }
                )
            )
        case .didTapLogoutButton:
            return .concat(
                .just(.setLoading(true)),
                signOutUseCase.execute()
                    .asObservable()
                    .flatMap { _ -> Observable<PrivacyViewReactor.Mutation> in
                        return .concat(
                            .just(.setLogout(true)),
                            .just(.setLoading(false))
                        )
                    }
                
            )
        case .didTapFamilyUserResign:
            return .concat(
                .just(.setLoading(true)),
                resignFamilyUseCase.execute()
                    .asObservable()
                    .compactMap { $0 }
                    .flatMap { entity -> Observable<PrivacyViewReactor.Mutation> in
                        return .concat(
                            .just(.setFamilyResign(entity.success)),
                            .just(.setLoading(false))
                        )
                    }
                
            )
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setBibbiAppInfo(appInfo):
            newState.appInfo = appInfo
        case let .setPrivacyItemModel(items):
            let sectionIndex = getSection(.privacyWithAuth([]))
            newState.section[sectionIndex] = .privacyWithAuth(items)
        case let .setAuthorizationItemModel(items):
            let sectionIndex = getSection(.userAuthorization([]))
            newState.section[sectionIndex] = .userAuthorization(items)
        case let .setLogout(isSuccess):
            newState.isSuccess = isSuccess
        case let .setFamilyResign(isFamilyResing):
            newState.isFamilyResign = isFamilyResing
        }
        
        return newState
    }
    
}



extension PrivacyViewReactor {
    
    func getSection(_ section: PrivacySectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.section.count where self.currentState.section[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
        
    }
    
}
