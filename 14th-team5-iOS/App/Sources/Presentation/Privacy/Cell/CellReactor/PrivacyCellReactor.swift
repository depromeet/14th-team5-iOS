//
//  PrivacyCellReactor.swift
//  App
//
//  Created by Kim dohyun on 12/16/23.
//

import Foundation

import ReactorKit


public final class PrivacyCellReactor: Reactor {
    public var initialState: State
    
    public typealias Action = NoAction
    
    public struct State {
        var descrption: String
    }
    
    init(descrption: String) {
        self.initialState = State(descrption: descrption)
    }
    
}
