//
//  Injected+PropertyWrapper.swift
//  Core
//
//  Created by 김건우 on 6/26/24.
//

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
