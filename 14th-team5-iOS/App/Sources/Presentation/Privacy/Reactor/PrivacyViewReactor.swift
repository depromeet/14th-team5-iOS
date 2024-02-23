//
//  PrivacyViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/15/23.
//

import Foundation

import Domain
import Data
import ReactorKit



public final class PrivacyViewReactor: Reactor {
    public var initialState: State
    private var privacyUseCase: PrivacyViewUseCaseProtocol
    private let memberId: String
    private let signOutUseCase: SignOutUseCaseProtocol
    
    public enum Action {
        case viewDidLoad
        case didTapLogoutButton
        case didTapFamilyUserResign
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setBibbiAppInfo(BibbiAppInfoResponse)
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
        @Pulse var appInfo: BibbiAppInfoResponse?
        @Pulse var section: [PrivacySectionModel]
        
    }
    
    public init(privacyUseCase: PrivacyViewUseCaseProtocol, signOutUseCase: SignOutUseCaseProtocol,  memberId: String) {
        self.privacyUseCase = privacyUseCase
        self.signOutUseCase = signOutUseCase
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
            let appKey: String = "87dca918-ef3b-4e1a-8261-786479fee634"
            let bibbiAppInfoParameter: BibbiAppInfoParameter = BibbiAppInfoParameter(appKey: appKey)
            return .concat(
                .just(.setLoading(true)),
                .merge(
                    privacyUseCase.executeBibbiAppInfo(parameter: bibbiAppInfoParameter)
                        .asObservable()
                        .withUnretained(self)
                        .flatMap { owner, entity -> Observable<PrivacyViewReactor.Mutation> in
                            owner.privacyUseCase.executePrivacyItems()
                                .asObservable()
                                .flatMap { items -> Observable<PrivacyViewReactor.Mutation> in
                                    
                                    var sectionItem: [PrivacyItemModel] = []
                                    items.forEach {
                                        sectionItem.append(.privacyWithAuthItem(PrivacyCellReactor(descrption: $0, isCheck: entity.latest)))
                                        
                                    }
                                    
                                    return .concat(
                                        .just(.setPrivacyItemModel(sectionItem)),
                                        .just(.setBibbiAppInfo(entity))
                                    )
                                }
                                
                        },
                    privacyUseCase.executeAuthorizationItem()
                        .asObservable()
                        .flatMap { items -> Observable<PrivacyViewReactor.Mutation> in
                            var sectionItems: [PrivacyItemModel] = []
                            items.forEach {
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
                privacyUseCase.executeAccountFamilyResign()
                    .asObservable()
                    .flatMap { entity -> Observable<PrivacyViewReactor.Mutation> in
                        return .concat(
                            .just(.setFamilyResign(entity.isSuccess)),
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
