//
//  CalendarFeedViewReactor.swift
//  App
//
//  Created by 김건우 on 12/8/23.
//

import Foundation

import ReactorKit
import RxSwift

final class CalendarFeedViewReactor: Reactor {
    // MARK: - Action
    enum Action { }
    
    // MARK: - Mutation
    enum Mutation { }
    
    // MARK: - State
    struct State { }
    
    // MARK: - Properties
    var initialState: State
    
    // MARK: - Intializer
    init() {
        self.initialState = State()
    }
}
