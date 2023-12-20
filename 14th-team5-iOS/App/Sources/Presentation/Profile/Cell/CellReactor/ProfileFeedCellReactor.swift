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
        var imageURL: String
        var title: String
        var date: String
    }
    
    init(imageURL: String, title: String, date: String) {
        self.initialState = State(imageURL: imageURL, title: title, date: date)
    }
    
    
}
