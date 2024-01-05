//
//  PrivacyViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/15/23.
//

import Foundation

import Domain
import ReactorKit



public final class PrivacyViewReactor: Reactor {
    public var initialState: State
    private var privacyUseCase: PrivacyViewUseCaseProtocol
    private let memberId: String
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setVersionCheck(Bool)
        case setPrivacyItemModel([PrivacyItemModel])
        case setAuthorizationItemModel([PrivacyItemModel])
    }
    
    public struct State {
        var isLoading: Bool
        var isCheck: Bool
        var memberId: String
        @Pulse var section: [PrivacySectionModel]
    }
    
    public init(privacyUseCase: PrivacyViewUseCaseProtocol, memberId: String) {
        self.privacyUseCase = privacyUseCase
        self.memberId = memberId
        self.initialState = State(
            isLoading: false,
            isCheck: false,
            memberId: memberId,
            section: [
                .privacyWithAuth([]),
                .userAuthorization([])
            ]
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            guard let appBundleId = Bundle.current.bundleIdentifier else { return .empty() }
            let storeParameter: BibbiStoreInfoParameter = BibbiStoreInfoParameter(bundleId: appBundleId)
            return .concat(
                .just(.setLoading(true)),
                .merge(
                    privacyUseCase.executeBibbiAppCheck(parameter: storeParameter)
                        .asObservable()
                        .withUnretained(self)
                        .flatMap { owner, isCheck -> Observable<PrivacyViewReactor.Mutation> in
                            owner.privacyUseCase.executePrivacyItems()
                                .asObservable()
                                .flatMap { items -> Observable<PrivacyViewReactor.Mutation> in
                                    var sectionItems: [PrivacyItemModel] = []
                                    items.forEach {
                                        sectionItems.append(.privacyWithAuthItem(PrivacyCellReactor(descrption: $0, isCheck: isCheck)))
                                    }
                                    
                                    return .concat(
                                        .just(.setVersionCheck(isCheck)),
                                        .just(.setPrivacyItemModel(sectionItems))
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
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setVersionCheck(isCheck):
            print("app Version Check: \(isCheck)")
            newState.isCheck = isCheck
        case let .setPrivacyItemModel(items):
            let sectionIndex = getSection(.privacyWithAuth([]))
            newState.section[sectionIndex] = .privacyWithAuth(items)
        case let .setAuthorizationItemModel(items):
            let sectionIndex = getSection(.userAuthorization([]))
            print("section Items:2 \(items)")
            newState.section[sectionIndex] = .userAuthorization(items)
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
