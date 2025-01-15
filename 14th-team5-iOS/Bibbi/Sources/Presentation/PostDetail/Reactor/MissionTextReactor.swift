//
//  MissionTextReactor.swift
//  App
//
//  Created by 김건우 on 5/7/24.
//

import Foundation

import ReactorKit

final class MissionTextReactor: Reactor {
    // MARK: - Action
    typealias Action = NoAction
    
    // MARK: - State
    struct State {
        var text: String
    }
    
    // MARK: - Properties
    var initialState: State
    
    // MARK: - Intializer
    init(text: String) {
        self.initialState = State(
            text: text
        )
    }
}
