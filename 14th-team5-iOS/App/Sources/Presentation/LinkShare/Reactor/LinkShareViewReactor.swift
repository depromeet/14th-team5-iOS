//
//  LinkShareViewReactor.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import Foundation

import Core
import ReactorKit
import RxSwift

final class LinkShareViewReactor: Reactor {
    // MARK: - Action
    enum Action { }
    
    // MARK: - Mutate
    enum Mutation { }
    
    // MARK: - State
    struct State { }
    
    // MARK: - Properties
    let initialState: State
    
    // MARK: - Intializer
    init() {
        self.initialState = State()
    }
}