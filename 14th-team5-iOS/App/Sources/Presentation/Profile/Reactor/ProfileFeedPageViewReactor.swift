//
//  ProfileFeedPageViewReactor.swift
//  App
//
//  Created by Kim dohyun on 5/16/24.
//

import Foundation

import Core
import ReactorKit

final class ProfileFeedPageViewReactor: Reactor {
    
    //MAKR: Property
    public var initialState: State
    @Injected private var provider: ServiceProviderProtocol
    
    enum Action {
        case updatePageViewController(Int)
    }
    
    struct State {
        var pageType: BibbiFeedType
    }
    
    enum Mutation {
        case reloadPageViewController(BibbiFeedType)
        case didShowPageViewController(BibbiFeedType)
    }
    
    init() {
        self.initialState = State(pageType: .survival)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let reloadPageViewMutation = provider.profilePageGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .didTapSegmentedPage(type):
                    
                    return .just(.reloadPageViewController(type))
                default:
                    return .empty()
                }
            }
        
        return .merge(mutation, reloadPageViewMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updatePageViewController(pageIndex):
            return .just(.didShowPageViewController(pageIndex == 0 ? .survival : .mission))
        }
    }

    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .reloadPageViewController(pageType):
            newState.pageType = pageType
            
        case let .didShowPageViewController(pageType):
            provider.profilePageGlobalState.didReceiveMemberId(memberId: pageType)
            newState.pageType = pageType
        }
        return newState
    }
    
}
