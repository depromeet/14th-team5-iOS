//
//  InjectIdentifier.swift
//  DIContainer
//
//  Created by 김건우 on 6/3/24.
//

import Foundation


// MARK: - Identifier

public struct InjectIdentifier<V> {
    
    private(set) var type: V.Type? = nil
    
    private(set) var key: String? = nil
    
    private init(
        type: V.Type? = nil,
        key: String? = nil
    ) {
        self.type = type
        self.key = key
    }
    
}


// MARK: - Extensions

extension InjectIdentifier: Hashable {
    
    public static func == (
        lhs: InjectIdentifier<V>,
        rhs: InjectIdentifier<V>
    ) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
        if let type = type {
            hasher.combine(ObjectIdentifier(type))
        }
    }
    
}


public extension InjectIdentifier {
    
    static func by(
        type: V.Type? = nil,
        key: String? = nil
    ) -> InjectIdentifier {
        return .init(type: type, key: key)
    }
    
}
