//
//  BibbiProfileViewReactor.swift
//  Core
//
//  Created by Kim dohyun on 12/17/23.
//

import Foundation

import ReactorKit


public class BibbiProfileViewReactor: Reactor {
    
    public var initialState: State
    public typealias Action = NoAction
    
    public struct State {
        @Pulse var profileImage: Data
        @Pulse var nickName: String
    }
    
    
    public init() {
        self.initialState = State(profileImage: Data(), nickName: "")
    }
    
}
