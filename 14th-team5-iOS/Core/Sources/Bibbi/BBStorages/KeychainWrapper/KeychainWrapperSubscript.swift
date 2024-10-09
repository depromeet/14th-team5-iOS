//
//  KeychainSubscript.swift
//  KeychainWrapper
//
//  Created by 김건우 on 5/13/24.
//

import Foundation

public extension KeychainWrapper {
    
    subscript(key: Key) -> Int? {
        get { integer(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript(key: Key) -> Float? {
        get { float(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript(key: Key) -> Double? {
        get { double(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript(key: Key) -> Bool? {
        get { bool(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript(key: Key) -> String? {
        get { string(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript(key: Key) -> (any NSCoding)? {
        get { object(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript<T>(key: Key) -> T? where T: Codable {
        get { object(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
    subscript(key: Key) -> Data? {
        get { data(forKey: key) }
        set {
            guard let value = newValue else { return }
            set(value, forKey: key.rawValue)
        }
    }
    
}

public extension KeychainWrapper {
    
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
    
    func string(forKey key: Key) -> String? {
        string(forKey: key.rawValue)
    }
    
    func object(forKey key: Key) -> (any NSCoding)? {
        object(forKey: key.rawValue)
    }
    
    func object<T>(forKey key: Key) -> T? where T: Decodable {
        object(forKey: key.rawValue)
    }
    
    func data(forKey key: Key) -> Data? {
        data(forKey: key.rawValue)
    }
    
}

public extension KeychainWrapper {
    
    func remove(forKey key: Key) {
        remove(forKey: key.rawValue)
    }
    
}

public extension KeychainWrapper {
    
    struct Key: Hashable, RawRepresentable, ExpressibleByStringLiteral {
        
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: String) {
            self.rawValue = value
        }
        
    }
    
}
