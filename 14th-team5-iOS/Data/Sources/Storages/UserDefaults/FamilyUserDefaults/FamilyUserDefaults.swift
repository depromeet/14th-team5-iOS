//
//  File.swift
//  Data
//
//  Created by 김건우 on 6/2/24.
//

import Core
import Foundation


public protocol FamilyInfoUserDefaultsType: UserDefaultsType {
    func saveFamilyId(_ familyId: String?)
    func loadFamilyId() -> String?
    
    func saveFamilyCreatedAt(_ familyCreatedAt: Date?)
    func loadFamilyCreatedAt() -> Date?
    
    func saveFamilyName(_ familyName: String?)
    func loadFamilyName() -> String?
}


final public class FamilyInfoUserDefaults: FamilyInfoUserDefaultsType {
 
    // MARK: - Intializer
    
    public init() { }
    
    
    // MARK: - Family Id
    
    public func saveFamilyId(_ familyId: String?) {
        userDefaults[.familyId] = familyId
    }
    
    public func loadFamilyId() -> String? {
        guard
            let familyId: String? = userDefaults[.familyId]
        else { return nil }
        return familyId
    }
    
    
    // MARK: - Family Created At
    
    public func saveFamilyCreatedAt(_ familyCreatedAt: Date?) {
        userDefaults[.familyCreatedAt] = familyCreatedAt
    }
    
    public func loadFamilyCreatedAt() -> Date? {
        guard
            let familyCreatedAt: Date? = userDefaults[.familyCreatedAt]
        else { return nil }
        return familyCreatedAt
    }
    
    
    // MARK: - Family Name
    
    public func saveFamilyName(_ familyName: String?) {
        userDefaults[.familyName] = familyName
    }
    
    public func loadFamilyName() -> String? {
        guard
            let familyName: String? = userDefaults[.familyName]
        else { return nil }
        return familyName
    }
    
}
