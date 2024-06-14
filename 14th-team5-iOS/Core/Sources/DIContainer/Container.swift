//
//  Container.swift
//  DIContainer
//
//  Created by 김건우 on 6/3/24.
//

import Foundation


// MARK: - Container

public class Container: Injectable {
    
    public static var standard = Container()
    
    public var dependencies: [AnyHashable : Any] = [:]
    
    required public init() { }
    
}


// MARK: - Property Wrapper

@propertyWrapper
public struct Injected<V> {
    
    // MARK: - Container
    public static func container() -> Injectable {
        Container.standard
    }
    
    // MARK: - Properties
    private let identifier: InjectIdentifier<V>
    private let container: Resolvable
    private let `default`: V?
    
    // MARK: - Intializer
    public init(
        identifier: InjectIdentifier<V>? = nil,
        container: Resolvable? = nil,
        default: V? = nil
    ) {
        self.identifier = identifier ?? .by(type: V.self)
        self.container = container ?? Self.container()
        self.default = `default`
    }
    
    // MARK: - Wrapped Value
    public lazy var wrappedValue: V = {
        if let value = try? container.resolve(identifier) {
            return value
        }
        
        if let `default` {
            return `default`
        }
        
        fatalError("Could not resolve with \(identifier) and default is nil")
    }()
    
}



@propertyWrapper
public struct InejctedSafe<V> {
    
    // MARK: - Container
    public static func container() -> Injectable {
        Container.standard
    }
    
    // MARK: - Properties
    private let identifier: InjectIdentifier<V>
    private let container: Resolvable
    
    // MARK: - Intiaializer
    public init(
        identifier: InjectIdentifier<V>? = nil,
        container: Resolvable? = nil
    ) {
        self.identifier = identifier ?? .by(type: V.self)
        self.container = container ?? Self.container()
    }
    
    // MARK: - WrappedValue
    public lazy var wrappedValue: V? = try? container.resolve(identifier)
    
}
