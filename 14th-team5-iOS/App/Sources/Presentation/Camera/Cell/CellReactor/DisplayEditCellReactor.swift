//
//  DisplayEditCellReactor.swift
//  App
//
//  Created by Kim dohyun on 12/13/23.
//

import Foundation

import ReactorKit



public final class DisplayEditCellReactor: Reactor {
    
    public typealias Action = NoAction
    
    public var initialState: State
    
    public struct State {
        var title: String
    }
    
    
    init(title: String) {
        self.initialState = State(title: title)
    }
    
    
}
