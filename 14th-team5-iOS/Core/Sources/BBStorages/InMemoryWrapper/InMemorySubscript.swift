//
//  InMemorySubscript.swift
//  Hello
//
//  Created by 김건우 on 6/2/24.
//

import Foundation

import RxSwift
import RxRelay


extension InMemoryWrapper {
    
    func registerInt(_ value: Int?, forKey key: Key) {
        register(value, forKey: key.rawValue)
    }
    
    func registerFloat(_ value: Float?, forKey key: Key) {
        register(value, forKey: key.rawValue)
    }
    
    func registerDouble(_ value: Double?, forKey key: Key) {
        register(value, forKey: key.rawValue)
    }
    
    func registerBool(_ value: Bool?, forKey key: Key) {
        register(value, forKey: key.rawValue)
    }
    
    func registerObject<T>(_ value: T?, forKey key: Key) where T: Encodable {
        register(value, forKey: key.rawValue)
    }
    
    func registerData(_ value: Data?, forKey key: Key) {
        register(value, forKey: key.rawValue)
    }
    
}


extension InMemoryWrapper {
    
    subscript(key: Key) -> Int? {
        get { integer(forKey: key.rawValue) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript(key: Key) -> Float? {
        get { float(forKey: key.rawValue) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript(key: Key) -> Double? {
        get { double(forKey: key.rawValue) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript(key: Key) -> Bool? {
        get { bool(forKey: key.rawValue) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript(key: Key) -> String? {
        get { string(forKey: key.rawValue) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript<T>(key: Key) -> T? where T: Codable {
        get { object(forKey: key.rawValue, of: T.self) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
}


extension InMemoryWrapper {
    
    subscript<T>(stream key: Key) -> Observable<T>? {
        return stream(forKey: key.rawValue)
    }
    
    subscript<T>(
        stream key: Key,
        of type: T.Type
    ) -> Observable<T>? where T: Decodable {
        return stream(forKey: key.rawValue, of: type)
    }
    
}


extension InMemoryWrapper {
    
    func integer(forKey key: Key) -> Int? {
        integer(forKey: key.rawValue)
    }
    
    func float(forKey key: Key) -> Float? {
        float(forKey: key.rawValue)
    }
    
    func double(forKey key: Key) -> Double? {
        double(forKey: key.rawValue)
    }
    
    func bool(forKey key: Key) -> Bool? {
        bool(forKey: key.rawValue)
    }
    
    func object<T>(forKey key: Key, of type: T.Type) -> T? where T: Decodable {
        object(forKey: key.rawValue, of: T.self)
    }
    
}



extension InMemoryWrapper {
    
    func remove(forKey key: Key) {
        remove(forKey: key.rawValue)
    }
    
}



extension InMemoryWrapper {
    
    public struct Key: Hashable, RawRepresentable, ExpressibleByStringLiteral {
     
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: StringLiteralType) {
            self.rawValue = value
        }
        
    }
    
}
