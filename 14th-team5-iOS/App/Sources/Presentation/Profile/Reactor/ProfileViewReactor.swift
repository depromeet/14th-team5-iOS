//
//  ProfileViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import Foundation

import Data
import ReactorKit


public final class ProfileViewReactor: Reactor {
    public var initialState: State
    private let profileRepository: ProfileViewImpl
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setFeedCategroySection([ProfileFeedSectionItem])
    }
    
    public struct State {
        var isLoading: Bool
        @Pulse var feedSection: [ProfileFeedSectionModel]
    }
    
    init(profileRepository: ProfileViewImpl) {
        self.profileRepository = profileRepository
        self.initialState = State(
            isLoading: false,
            feedSection: [.feedCategory([])]
        )
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(true)),
                .just(.setLoading(false))
            )
            
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setFeedCategroySection(section):
            let sectionIndex = getSection(.feedCategory([]))
            newState.feedSection[sectionIndex] = .feedCategory(section)
        }
        
        return newState
    }
    
}


extension ProfileViewReactor {
 
    func getSection(_ section: ProfileFeedSectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.feedSection.count where self.currentState.feedSection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
}
