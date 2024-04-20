//
//  MainFamilyCellReactor.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

import ReactorKit

enum RankBadge: Int {
    case one = 1
    case two
    case three
}

final class MainFamilyCellReactor: Reactor {
    enum Action {
        case fetchData
    }
    
    enum Mutation {
        case setData
    }
    
    struct State {
        let profileData: ProfileData
        var profile: (String?, String) = (nil,"")
        var rank: Int? = nil
        var isShowBirthdayBadge: Bool = false
        var isShowPickButton: Bool = false
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension MainFamilyCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchData:
            return Observable.just(.setData)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setData:
            newState.profile = (currentState.profileData.profileImageURL, currentState.profileData.name)
            newState.rank = currentState.profileData.postRank
            newState.isShowBirthdayBadge = currentState.profileData.isShowBirthdayMark
            newState.isShowPickButton = currentState.profileData.isShowPickIcon
        }
        
        return newState
    }
}
