//
//  InMemoryStore.swift
//  Hello
//
//  Created by 김건우 on 6/2/24.
//

import Foundation

import RxSwift
import RxRelay

public struct InMemoryStore<T> {
    
    // MARK: - Typealias
    public typealias Relay = BehaviorRelay<T?>
    
    // MARK: - Properties
    private var relay = Relay(value: nil)
    
    // MARK: - Intializer
    public init(
        initalValue: T? = nil
    ) {
        self.relay.accept(initalValue)
    }
    
    // MARK: - Read

    public var value: T? {
        relay.value
    }
    
    public var stream: Relay { relay }

    
    // MARK: - Update
    
    public func set(
        _ value: T?
    ) {
        relay.accept(value)
    }
    
}

