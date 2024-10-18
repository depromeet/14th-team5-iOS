//
//  MemoriesCalendarPostImageReactor.swift
//  App
//
//  Created by 김건우 on 10/17/24.
//

import Foundation

import ReactorKit

final public class MemoriesCalendarPostImageReactor: Reactor {
    
    public typealias Action = NoAction
    
    // MARK: - State
    
    public struct State { }
    
    // MARK: - Properties
    
    public let initialState: State
    
    // MARK: - Intializer
    
    public init() { self.initialState = State() }
    
}

