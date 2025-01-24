//
//  ProfileFeedEmptyCellReactor.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation

import ReactorKit

public final class ProfileFeedEmptyCellReactor: Reactor {
    public var initialState: State
    
    public typealias Action = NoAction
    
    public struct State {
        var descrption: String
        var resource: String
    }
    
    public init(descrption: String, resource: String) {
        self.initialState = State(descrption: descrption, resource: resource)
    }
    
}
