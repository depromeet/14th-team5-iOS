//
//  main.swift
//  UserDefaultsWrapper
//
//  Created by 김건우 on 5/14/24.
//

import Foundation

final public class UserDefaultsWrapper {
    
    // MARK: - Properties
    
    public static let standard = UserDefaultsWrapper()
    
    private let userDefaults: UserDefaults!
    
    private(set) public var suitName: String
    
    private static let defaultSuitName: String = {
        "UserDefaultsWrapper"
    }()
    
    
    // MARK: - Intializer
    
    convenience init() {
        self.init(suitName: UserDefaultsWrapper.defaultSuitName)
    }
    
    init(suitName: String) {
        self.suitName = suitName
        self.userDefaults = UserDefaults(suiteName: suitName)
    }
    
    
    // MARK: - Create
    
    public func set(
        _ value: Int,
        forKey key: String
    ) {
        userDefaults.set(value, forKey: key)
    }
    
    public func set(
        _ value: Float,
        forKey key: String
    ) {
        userDefaults.set(value, forKey: key)
    }
    
    public func set(
        _ value: Double,
        forKey key: String
    ) {
        userDefaults.set(value, forKey: key)
    }
    
    public func set(
        _ value: Bool,
        forKey key: String
    ) {
        userDefaults.set(value, forKey: key)
    }
    
    public func set(
        _ value: String,
        forKey key: String
    ) {
        if let data = value.data(using: .utf8) {
            set(data, forKey: key)
        } else {
            return
        }
    }
    
    public func set<T>(
        _ value: T,
        forKey key: String
    ) where T: Encodable {
        if let data = try? JSONEncoder().encode(value) {
            set(data, forKey: key)
        } else {
            return
        }
    }
    
    public func set(
        _ value: Data,
        forKey key: String
    ) {
        userDefaults.set(value, forKey: key)
    }
    
    
    // MARK: - Read
    
    public func integer(forKey key: String) -> Int? {
        guard let value = userDefaults.value(forKey: key) as? Int else {
            return nil
        }
        return value
    }
    
    public func float(forKey key: String) -> Float? {
        guard let value = userDefaults.value(forKey: key) as? Float else {
            return nil
        }
        return value
    }
    
    public func double(forKey key: String) -> Double? {
        guard let value = userDefaults.value(forKey: key) as? Double else {
            return nil
        }
        return value
    }
    
    public func bool(forKey key: String) -> Bool? {
        guard let value = userDefaults.value(forKey: key) as? Bool else {
            return nil
        }
        return value
    }
    
    public func string(forKey key: String) -> String? {
        guard let data = data(forKey: key) else {
            return nil
        }
        
        if let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            return nil
        }
    }
    
    public func object<T>(
        forKey key: String,
        of type: T.Type
    ) -> T? where T: Decodable {
        guard let data = data(forKey: key) else {
            return nil
        }
        
        if let value = try? JSONDecoder().decode(type, from: data) {
            return value
        } else {
            return nil
        }
    }
    
    public func data(forKey key: String) -> Data? {
        guard let value = userDefaults.value(forKey: key) as? Data else {
            return nil
        }
        return value
    }
    
    
    // MARK: - Delete
    
    public func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    public func removeAll() {
        userDefaults.removePersistentDomain(forName: suitName)
    }
    
    
    // MARK: - Register
    
    /// 해당 키에 값이 비어있다면 넣을 기본 값을 등록합니다.
    ///
    /// 앱 델리게이트의 `application(_ application:didFinishLaunchingWithOptions:)` 메서드에서 등록해야 합니다.
    /// - Parameter values: [UserDefaultsWrapper.Key: Any]
    public func register(_ values: [Key: Any]) {
        var newValues = [String: Any]()
        values.forEach { newValues.updateValue($0.value, forKey: $0.key.rawValue) }
        register(newValues)
    }
    
    /// 해당 키에 값이 비어있다면 넣을 기본 값을 등록합니다.
    ///
    /// 앱 델리게이트의 `application(_ application:didFinishLaunchingWithOptions:)` 메서드에서 등록해야 합니다.
    /// - Parameter values: [String: Any]
    public func register(_ values: [String: Any]) {
        userDefaults.register(defaults: values)
    }
    
}
