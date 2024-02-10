//
//  ProfileDetailViewReactor.swift
//  App
//
//  Created by Kim dohyun on 2/10/24.
//

import Foundation


import ReactorKit


final class ProfileDetailViewReactor: Reactor {
    var initialState: State
    
    typealias Action = NoAction
    
    
    struct State {
        @Pulse var profileURL: URL
        @Pulse var userNickname: String
    }
    
    init(profileURL: URL, userNickname: String) {
        self.initialState = State(profileURL: profileURL, userNickname: userNickname)
    }
    
}
