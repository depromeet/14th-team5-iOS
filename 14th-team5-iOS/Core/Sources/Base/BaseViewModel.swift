//
//  BaseViewModel.swift
//  Core
//
//  Created by 김건우 on 1/26/24.
//

import SwiftUI

import ReactorKit

open class BaseViewModel<R: Reactor, S: ViewModelState>: ObservableObject {
    public weak var reactor: R?
    @Published public var state: S
    
    public init(reactor: R? = nil, state: S) {
        self.reactor = reactor
        self.state = state
    }
    
    public func onEvent<T: ViewModelAction>(action: T) { }
    public func updateState(state: ViewModelState) { }
}

public protocol ViewModelState { }
public protocol ViewModelAction { }
