//
//  BaseDIContainer.swift
//  Core
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

@available(*, deprecated, renamed: "BaseContainer")
public protocol BaseDIContainer {
    
    associatedtype ViewContrller
    associatedtype Repository
    associatedtype Reactor
    
    
    func makeViewController() -> ViewContrller
    func makeRepository() -> Repository
    func makeReactor() -> Reactor
    
}
