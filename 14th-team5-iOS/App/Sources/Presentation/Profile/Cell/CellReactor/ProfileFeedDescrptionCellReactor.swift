//
//  ProfileFeedDescrptionCellReactor.swift
//  App
//
//  Created by Kim dohyun on 2/11/24.
//

import Foundation

import ReactorKit

public final class ProfileFeedDescrptionCellReactor: Reactor {
    
    public var initialState: State
    
    public typealias Action = NoAction
    
    public struct State {
        var content: String
    }
    
    init(content: String) {
        self.initialState = State(content: content)
    }
    
}
