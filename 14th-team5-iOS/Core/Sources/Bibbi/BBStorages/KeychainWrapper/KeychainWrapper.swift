//
//  KeychainWrapper.swift
//  KeychainWrapper
//
//  Created by 김건우 on 5/13/24.
//

import Foundation

final public class KeychainWrapper {
    
    // MARK: - Properties
    
    public static let standard = KeychainWrapper()
    
    private let SecMatchLimit: String! = kSecMatchLimit as String
    private let SecReturnData: String! = kSecReturnData as String
    private let SecValueData: String! = kSecValueData as String
    private let SecAttrAccessible: String! = kSecAttrAccessible as String
    private let SecClass: String! = kSecClass as String
    private let SecAttrService: String! = kSecAttrService as String
    private let SecAttrGeneric: String! = kSecAttrGeneric as String
    private let SecAttrAccount: String! = kSecAttrAccount as String
    private let SecAttrAccessGroup: String! = kSecAttrAccessGroup as String
    private let SecAttrSynchronizable: String! = kSecAttrSynchronizable as String
    
    private(set) public var serviceName: String
    private(set) public var accessGroup: String?
    
    private static let defaultServiceName: String = {
        return Bundle.main.bundleIdentifier ?? "KeychainWrapper"
    }()
    
    
    // MARK: - Intializer
    
    public init(
        serviceName: String,
        accessGroup: String? = nil
    ) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }
    
    private convenience init() {
        self.init(serviceName: KeychainWrapper.defaultServiceName)
    }
    
    
    
    // MARK: - Read
    
    public func integer(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Int? {
        guard let numberValue = object(
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        ) as? NSNumber else {
            return nil
        }
        
        return numberValue.intValue
    }
    
    public func float(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Float? {
        guard let numberValue = object(
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        ) as? NSNumber else {
            return nil
        }
        
        return numberValue.floatValue
    }
    
    public func double(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Double? {
        guard let numberValue = object(
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        ) as? NSNumber else {
            return nil
        }
        
        return numberValue.doubleValue
    }
    
    public func bool(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool? {
        guard let numberValue = object(
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        ) as? NSNumber else {
            return nil
        }
        
        return numberValue.boolValue
    }
    
    public func string(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> String? {
        guard let keychainData = data(
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        ) else {
            return nil
        }
        
        return String(data: keychainData, encoding: .utf8)
    }
    
    public func object(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> (any NSCoding)? {
        guard let keychainData = data(
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        ) else {
            return nil
        }
        
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: keychainData)
    }
    
    public func object<T>(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> T? where T: Decodable {
        guard let keychainData = data(
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        ) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: keychainData)
    }
    
    public func data(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Data? {
        var keychainQueryDictionary = setupKeychainQueryDictionary(
            forkey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        )
        keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
        keychainQueryDictionary[SecReturnData] = kCFBooleanTrue
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(
            keychainQueryDictionary as CFDictionary,
            &result
        )
        
        return status == noErr ? result as? Data : nil
    }
    
    
    

    // MARK: - Create
    
    @discardableResult
    public func set(
        _ value: Int,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        return set(
            NSNumber(value: value),
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        )
    }
    
    @discardableResult
    public func set(
        _ value: Float,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        return set(
            NSNumber(value: value),
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        )
    }
    
    @discardableResult
    public func set(
        _ value: Double,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        return set(
            NSNumber(value: value),
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        )
    }
    
    @discardableResult
    public func set(
        _ value: Bool,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        return set(
            NSNumber(value: value),
            forKey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        )
    }
    
    @discardableResult
    public func set(
        _ value: String,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        if let data = value.data(using: .utf8) {
            return set(
                data, 
                forKey: key,
                withAccessibility: accessibility,
                isSynchronizable: isSynchronizable
            )
        } else {
            return false
        }
    }
    
    @discardableResult
    public func set(
        _ value: any NSCoding,
        forKey key: String,
        withAccessibility accessibiilty: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        if let data = try? NSKeyedArchiver.archivedData(
            withRootObject: value,
            requiringSecureCoding: false
        ) {
            return set(
                data,
                forKey: key,
                withAccessibility: accessibiilty,
                isSynchronizable: isSynchronizable
            )
        } else {
            return false
        }
    }
    
    @discardableResult
    public func set(
        _ value: any Encodable,
        forKey key: String,
        withAccessibility accessibiilty: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        if let data = try? JSONEncoder().encode(value) {
            return set(
                data,
                forKey: key,
                withAccessibility: accessibiilty,
                isSynchronizable: isSynchronizable
            )
        } else {
            return false
        }
    }
    
    @discardableResult
    public func set(
        _ value: Data,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        var keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(
            forkey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        )
        keychainQueryDictionary[SecValueData] = value
        
        if let accessibility = accessibility {
            keychainQueryDictionary[SecAttrAccessible] = accessibility.keychainAttrValue
        } else {
            keychainQueryDictionary[SecAttrAccessible] = KeychainItemAccessibility.afterFirstUnlock.keychainAttrValue
        }
        
        let status: OSStatus = SecItemAdd(keychainQueryDictionary as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(
                value,
                forKey: key,
                withAccessibility: accessibility,
                isSynchronizable: isSynchronizable
            )
        } else {
            return false
        }
    }
    
    // MARK: - Update
    
    private func update(
        _ value: Data,
        forKey key: String,
        withAccessibility accessiblity: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        var keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(
            forkey: key, 
            withAccessibility: accessiblity,
            isSynchronizable: isSynchronizable
        )
        let updateDictionary = [SecValueData: value]
        
        if let accessibility = accessiblity {
            keychainQueryDictionary[SecAttrAccessible] = accessibility.keychainAttrValue
        }
        
        let status: OSStatus = SecItemUpdate(
            keychainQueryDictionary as CFDictionary,
            updateDictionary as CFDictionary
        )
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    
    
    // MARK: - Delete
    
    @discardableResult
    public func remove(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> Bool {
        let keychainQueryDictionary = setupKeychainQueryDictionary(
            forkey: key,
            withAccessibility: accessibility,
            isSynchronizable: isSynchronizable
        )
        
        let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    @discardableResult
    public func removeAllKeys() -> Bool {
        var keychainQueryDictionary: [String: Any] = [
            SecClass: kSecClassGenericPassword,
            SecAttrService: serviceName
        ]
        
        if let accessGroup = accessGroup {
            keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
        }
        
        let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: - Keychain Query Dictionary
    
    private func setupKeychainQueryDictionary(
        forkey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil,
        isSynchronizable: Bool = false
    ) -> [String: Any] {
        var keychainQueryDictionary: [String: Any] = [SecClass: kSecClassGenericPassword]
        
        keychainQueryDictionary[SecAttrService] = serviceName
        if let accessibility = accessibility {
            keychainQueryDictionary[SecAttrAccessible] = accessibility.keychainAttrValue
        }
        
        if let accessGroup = accessGroup {
            keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
        }
        
        let encodedIdentifier: Data? = key.data(using: .utf8)
        keychainQueryDictionary[SecAttrAccount] = encodedIdentifier
        
        keychainQueryDictionary[SecAttrSynchronizable] = isSynchronizable ? kCFBooleanTrue : kCFBooleanFalse
        
        return keychainQueryDictionary
    }
}
