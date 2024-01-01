//
//  AccountResignViewReactor.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation

import ReactorKit
import RxSwift

final class AccountResignViewReactor: Reactor {
    var initialState: State
    
    typealias Action = NoAction
    
    struct State {
        var isLoading: Bool
    }
    
    init() {
        self.initialState = State(isLoading: false)
    }
    
}
