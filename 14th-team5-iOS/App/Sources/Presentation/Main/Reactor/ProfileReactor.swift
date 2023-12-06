//
//  ProfileReactor.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import ReactorKit
import RxSwift

class ProfileReactor: Reactor {
    enum Action {
        case setProfile(name: String, profileImageURL: String)
    }

    enum Mutation {
        case setProfile(name: String, profileImageURL: String)
    }

    struct State {
        var name: String = ""
        var profileImageURL: String = ""
    }

    let initialState: State = State()
}

extension ProfileReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setProfile(name, imageURL):
            return Observable.just(.setProfile(name: name, profileImageURL: imageURL))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setProfile(name, imageURL):
            newState.name = name
            newState.profileImageURL = imageURL
        }
        return newState
    }
}
