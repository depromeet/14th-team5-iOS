//
//  InjectedSafe+PropertyWrapper.swift
//  Core
//
//  Created by 김건우 on 6/26/24.
//

@propertyWrapper
public struct InjectedSafe<V> {
    
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
