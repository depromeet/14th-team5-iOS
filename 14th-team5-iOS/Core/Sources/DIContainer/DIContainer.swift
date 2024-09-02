//
//  DIContainer.swift
//  DIContainer
//
//  Created by 김건우 on 6/3/24.
//

import Foundation

// MARK: - Resolvable

public protocol Resolvable {
    
    func resolve<V>(_ identifier: InjectIdentifier<V>) throws -> V
    
}


// MARK: - ResolvableError

public enum ResolvableError: Error {
    
    case dependencyNotFound(Any.Type?, String?)
    
}

extension ResolvableError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .dependencyNotFound(type, key):
            var message = "Could not find dependency for "
            if let type = type {
                message += "type: \(type) "
            } else if let key = key {
                message += "key: \(key)"
            }
            return message
        }
    }
    
}



// MARK: - Injectable

public protocol Injectable: Resolvable, AnyObject {
    
    init()
    
    var dependencies: [AnyHashable: Any] { get set }
    
    func register<V>(_ identifier: InjectIdentifier<V>, _ resolve: (Resolvable) throws -> V)
    func remove<V>(_ identifier: InjectIdentifier<V>)
    
}

public extension Injectable {
    
    
    // MARK: - Register
    
    func register<V>(
        _ identifier: InjectIdentifier<V>,
        _ resolve: (Resolvable) throws -> V
    ) {
        do {
            self.dependencies[identifier] = try resolve(self)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func register<V>(
        _ identifier: InjectIdentifier<V>,
        object: @autoclosure () -> V
    ) {
        self.register(identifier) { _ in object() }
    }
        
    func register<V>(
        type: V.Type? = nil,
        key: String? = nil,
        _ resolve: (Resolvable) throws -> V
    ) {
        self.register(.by(type: type, key: key), resolve)
    }
    
    // MARK: - Remove
    
    func remove<V>(_ identifier: InjectIdentifier<V>) {
        self.dependencies.removeValue(forKey: identifier)
    }
    
    func remove<V>(
        type: V.Type? = nil,
        key: String? = nil
    ) {
        let identifier = InjectIdentifier.by(type: type, key: key)
        self.dependencies.removeValue(forKey: identifier)
    }
    
    func removeAllDependencies() {
        self.dependencies.removeAll()
    }
    
    
    // MARK: - Resolve
    
    func resolve<V>(_ identifier: InjectIdentifier<V>) throws -> V {
        guard
            let dependency = dependencies[identifier] as? V
        else {
            throw ResolvableError.dependencyNotFound(identifier.type, identifier.key)
        }
        return dependency
    }
    
    func resolve<V>(
        type: V.Type? = nil,
        key: String? = nil
    ) throws -> V {
        try self.resolve(.by(type: type, key: key))
    }
    
    
}
