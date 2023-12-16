//
//  PrivacyViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/15/23.
//

import Foundation

import Data
import ReactorKit



public final class PrivacyViewReactor: Reactor {
    public var initialState: State
    private var privacyRepository: PrivacyViewImpl
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setPrivacyItemModel([PrivacyItemModel])
        case setAuthorizationItemModel([PrivacyItemModel])
    }
    
    public struct State {
        var isLoading: Bool
        @Pulse var section: [PrivacySectionModel]
    }
    
    public init(privacyRepository: PrivacyViewImpl) {
        self.privacyRepository = privacyRepository
        self.initialState = State(
            isLoading: false,
            section: [
                .privacyWithAuth([]),
                .userAuthorization([])
            ]
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(true)),
                .merge(
                    privacyRepository.fetchPrivacyItem()
                        .asObservable()
                        .flatMap { items -> Observable<PrivacyViewReactor.Mutation> in
                            var sectionItems: [PrivacyItemModel] = []
                            items.forEach {
                                sectionItems.append(.privacyWithAuthItem(PrivacyCellReactor(descrption: $0)))
                            }
                            return .concat(
                                .just(.setPrivacyItemModel(sectionItems))
                            )
                        },
                    privacyRepository.fetchAuthorizationItem()
                        .asObservable()
                        .flatMap { items -> Observable<PrivacyViewReactor.Mutation> in
                            var sectionItems: [PrivacyItemModel] = []
                            items.forEach {
                                sectionItems.append(.userAuthorizationItem(PrivacyCellReactor(descrption: $0)))
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
