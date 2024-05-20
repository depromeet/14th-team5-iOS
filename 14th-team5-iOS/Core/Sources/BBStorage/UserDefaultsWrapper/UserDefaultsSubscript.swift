//
//  UserDefaultsSubscript.swift
//  UserDefaultsWrapper
//
//  Created by 김건우 on 5/14/24.
//

import Foundation

public extension UserDefaultsWrapper {
    
    subscript(key: Key) -> Int? {
        get { integer(forKey: key)  }
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
    
    subscript<T>(key: Key) -> T? where T: Codable {
        get { object(forKey: key, of: T.self) }
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

public extension UserDefaultsWrapper {
    
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
    
    func object<T>(
        forKey key: Key,
        of: T.Type
    ) -> T? where T: Decodable {
        object(forKey: key.rawValue, of: T.self)
    }
    
    func data(forKey key: Key) -> Data? {
        data(forKey: key.rawValue)
    }
    
}

public extension UserDefaultsWrapper {
    
    func remove(forKey key: Key) {
        remove(forKey: key.rawValue)
    }
    
}

public extension UserDefaultsWrapper {
    
    struct Key: Hashable, RawRepresentable, ExpressibleByStringLiteral {
        
        public var rawValue: String
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: String) {
            self.rawValue = value
        }
        
    }
    
}
