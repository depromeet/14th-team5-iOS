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
    }
    
    public struct State {
        var isLoading: Bool
    }
    
    init(profileRepository: ProfileViewImpl) {
        self.profileRepository = profileRepository
        self.initialState = State(isLoading: false)
    }
    
    
}
