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
    public enum Action {
        case didTapDate(Date)
    }
    
    // MARK: - Mutation
    public enum Mutation { 
        case presentFeed(Date)
    }
    
    // MARK: - State
    public struct State { 
        var selectedDate: Date
        
        init(_ selectedDate: Date) {
            self.selectedDate = selectedDate
        }
    }
    
    // MARK: - Properties
    public var initialState: State
    public let provider: GlobalStateProviderType
    
    // MARK: - Intializer
    init(_ state: State, provider: GlobalStateProviderType) {
        self.initialState = state
        self.provider = provider
    }
}
