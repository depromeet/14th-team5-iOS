//
//  ProfileImageSelctReactor.swift
//  App
//
//  Created by geonhui Yu on 12/9/23.
//

import UIKit
import ReactorKit

final class ProfileImageSelctReactor: Reactor {
    enum Action {
        case setProfileImage
    }
    
    enum Mutation {
        case setProfileImage
    }
    
    struct State {
        var selectedProfileImage: UIImage?
    }
    
    let initialState: State = State()
}

extension ProfileImageSelctReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setProfileImage:
            Observable.just(Mutation.setProfileImage)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setProfileImage:
            newState.selectedProfileImage = UIImage()
        }
        return newState
    }
}
