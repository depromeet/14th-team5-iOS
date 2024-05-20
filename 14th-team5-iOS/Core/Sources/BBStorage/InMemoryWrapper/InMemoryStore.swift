//
//  InMemoryStore.swift
//  Core
//
//  Created by 김건우 on 5/20/24.
//

import Foundation

import RxSwift
import RxRelay

public struct InMemoryStore<T>: ~Copyable {
    
    // MARK: - Properties
    private var relay = BehaviorRelay<T?>(value: nil)
    
    // MARK: - Intializer
    public init(
        initalValue: T? = nil
    ) {
        self.relay.accept(initalValue)
    }
    
    // MARK: - Deinitalizer
    
    deinit { relay.accept(nil) }
    

    
    // MARK: - Read

    public func value() -> T? {
        relay.value
    }
    
    public var stream: BehaviorRelay<T?> { relay }

    
    // MARK: - Update
    
    public func set(
        _ value: T?
    ) {
        relay.accept(value)
    }
    
}
