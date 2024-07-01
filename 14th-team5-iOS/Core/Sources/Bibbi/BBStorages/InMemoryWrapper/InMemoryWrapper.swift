//
//  InMemoryWraper.swift
//  Hello
//
//  Created by 김건우 on 6/2/24.
//

import Foundation

import RxSwift
import RxCocoa

final public class InMemoryWrapper {
    
    // MARK: - Typealias
    public typealias Store = InMemoryStore
    
    // MARK: - Properties
    public static var standard = InMemoryWrapper()
    
    
    
    // MARK: - Dictionary
    private var relays: [String: Store<Any>] = [:]

    
    
    // MARK: - Intializer
    private init() { }
    
    

    // MARK: - Register
    
    public func register(
        _ value: Int?,
        forKey key: String
    ) {
        if relays[key] == nil {
            relays[key] = Store(initalValue: value)
        }
    }
    
    public func register(
        _ value: Float?,
        forKey key: String
    ) {
        if relays[key] == nil {
            relays[key] = Store(initalValue: value)
        }
    }
    
    public func register(
        _ value: Double?,
        forKey key: String
    ) {
        if relays[key] == nil {
            relays[key] = Store(initalValue: value)
        }
    }
    
    public func register(
        _ value: Bool?,
        forKey key: String
    ) {
        if relays[key] == nil {
            relays[key] = Store(initalValue: value)
        }
    }
    
    public func register<T>(
        _ value: T?,
        forKey key: String
    ) where T: Encodable {
        if let data = try? JSONEncoder().encode(value) {
            register(data, forKey: key)
        }
    }
    
    public func register(
        _ data: Data?,
        forKey key: String
    ) {
        if relays[key] == nil {
            relays[key] = Store(initalValue: data)
        }
    }

    
    
    // MARK: - Stream
    
    public func stream<T>(
        forKey key: String
    ) -> Observable<T>? {
        return relays[key]?.stream.asObservable()
            .compactMap { $0 as? T }
    }
    
    public func stream<T>(
        forKey key: String,
        of type: T.Type
    ) -> Observable<T>? where T: Decodable {
        return relays[key]?.stream.asObservable()
            .compactMap {
                if let data = $0 as? Data,
                   let value = try? JSONDecoder().decode(type, from: data) {
                    return value
                }
                return nil
            }
    }
    
    
    
    // MARK: - Read
    
    public func integer(
        forKey key: String
    ) -> Int? {
        if let value = relays[key]?.value as? Int {
            return value
        }
        return nil
    }
    
    public func float(
        forKey key: String
    ) -> Float? {
        if let value = relays[key]?.value as? Float {
            return value
        }
        return nil
    }
    
    public func double(
        forKey key: String
    ) -> Double? {
        if let value = relays[key]?.value as? Double {
            return value
        }
        return nil
    }
    
    public func bool(
        forKey key: String
    ) -> Bool? {
        if let value = relays[key]?.value as? Bool {
            return value
        }
        return nil
    }
    
    public func string(
        forKey key: String
    ) -> String? {
        if let value = relays[key]?.value as? String {
            return value
        }
        return nil
    }
    
    public func object<T>(
        forKey key: String,
        of type: T.Type
    ) -> T? where T: Decodable {
        if let data = data(forKey: key),
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
    
    
    public func data(
        forKey key: String
    ) -> Data? {
        if let data = relays[key]?.value as? Data {
            return data
        }
        return nil
    }
    
    
    
    // MARK: - Update
    
    @discardableResult
    public func set(
        _ value: Int,
        forKey key: String
    ) -> Bool {
        if let relay = relays[key] {
            relay.set(value)
            return true
        }
        return false
    }
    
    @discardableResult
    public func set(
        _ value: Float,
        forKey key: String
    ) -> Bool {
        if let relay = relays[key] {
            relay.set(value)
            return true
        }
        return false
    }
    
    @discardableResult
    public func set(
        _ value: Double,
        forKey key: String
    ) -> Bool {
        if let relay = relays[key] {
            relay.set(value)
            return true
        }
        return false
    }
    
    @discardableResult
    public func set(
        _ value: Bool,
        forKey key: String
    ) -> Bool {
        if let relay = relays[key] {
            relay.set(value)
            return true
        }
        return false
    }
    
    @discardableResult
    public func set(
        _ value: String,
        forKey key: String
    ) -> Bool {
        if let relay = relays[key] {
            relay.set(value)
            return true
        }
        return false
    }
    
    @discardableResult
    public func set<T>(
        _ value: T,
        forKey key: String
    ) -> Bool where T: Encodable {
        if let data = try? JSONEncoder().encode(value) {
            set(data, forKey: key)
            return true
        }
        return false
    }
    
    @discardableResult
    public func set(
        _ value: Data,
        forKey key: String
    ) -> Bool {
        if let relay = relays[key] {
            relay.set(value)
            return true
        }
        return false
    }
    
    
    // MARK: - Delete
    
    public func remove(
        forKey key: String
    ) {
        if let relay = relays[key] {
            relay.set(nil)
        }
    }
    
    public func removeAll() {
        for key in relays.keys {
            remove(forKey: key)
        }
    }
    
    
    
    // MARK: - Helper
    
    
    
}
