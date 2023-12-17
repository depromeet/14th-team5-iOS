//
//  CalendarFeedViewReactor.swift
//  App
//
//  Created by 김건우 on 12/8/23.
//

import Foundation

import Core
import ReactorKit
import RxSwift

public final class CalendarFeedViewReactor: Reactor {
    // MARK: - Action
    public enum Action { }
    
    // MARK: - Mutation
    public enum Mutation { }
    
    // MARK: - State
    public struct State { }
    
    // MARK: - Properties
    public var initialState: State
    public let provider: GlobalStateProviderType
    
    // MARK: - Intializer
    init(provider: GlobalStateProviderType) {
        self.initialState = State()
        self.provider = provider
    }
}
