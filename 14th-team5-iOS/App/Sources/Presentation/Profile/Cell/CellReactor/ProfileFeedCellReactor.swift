//
//  ProfileFeedCellReactor.swift
//  App
//
//  Created by Kim dohyun on 12/18/23.
//

import Foundation


import ReactorKit


public final class ProfileFeedCellReactor: Reactor {
    public var initialState: State
    
    public typealias Action = NoAction
    
    public struct State {
        var title: String
        var date: String
    }
    
    init(title: String, date: String) {
        self.initialState = State(title: title, date: date)
    }
    
    
}
