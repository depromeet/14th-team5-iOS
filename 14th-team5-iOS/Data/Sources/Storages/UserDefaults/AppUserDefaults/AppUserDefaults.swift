//
//  AppUserDefaults.swift
//  Data
//
//  Created by 김건우 on 8/24/24.
//

import Core
import Foundation

public protocol AppUserDefaultsType: UserDefaultsType {
    func saveIsFirstLaunchApp(_ value: Bool?)
    func loadIsFirstLaunchApp() -> Bool?
    
    func saveIsFirstChangeFamilyName(_ value: Bool?)
    func loadIsFirstChangeFamilyName() -> Bool?
    
    func saveIsFirstShowWidgetAlert(_ value: Bool?)
    func loadIsFirstShowWidgetAlert() -> Bool?
    
    func saveIsFirstOnboarding(_ value: Bool?)
    func loadIsFirstOnboarding() -> Bool?
    
    func saveIsFirstFamilyManagement(_ value: Bool)
    func loadIsFirstFamilyManagement() -> Bool
    
    func saveInviteCode(_ inviteCode: String)
    func loadInviteCode() -> String?
}

final public class AppUserDefaults: AppUserDefaultsType {

    // MARK: - Intializer
    
    public init() { }
    
    
    // MARK: - Is First Launch App
    
    public func saveIsFirstLaunchApp(_ value: Bool?) {
        userDefaults[.isFirstLaunchApp] = value
    }
    
    public func loadIsFirstLaunchApp() -> Bool? {
        guard
            let value: Bool? = userDefaults[.isFirstLaunchApp]
        else { return nil }
        return value
    }
    
    
    // MARK: - Is First Change Family Name
    
    public func saveIsFirstChangeFamilyName(_ value: Bool?) {
        userDefaults[.isFirstChangeFamilyName] = value
    }
    
    public func loadIsFirstChangeFamilyName() -> Bool? {
        guard
            let value: Bool? = userDefaults[.isFirstChangeFamilyName]
        else { return nil }
        return value
    }
    
    
    // MARK: - Is First Show Widget Alert
    
    public func saveIsFirstShowWidgetAlert(_ value: Bool?) {
        userDefaults[.isFirstShowWidgetAlert] = value
    }
    
    public func loadIsFirstShowWidgetAlert() -> Bool? {
        guard
            let value: Bool? = userDefaults[.isFirstShowWidgetAlert]
        else { return nil }
        return value
    }
    
    
    // MARK: - Invite Code
    
    public func saveInviteCode(_ inviteCode: String) {
        userDefaults[.inviteCode] = inviteCode
    }
    
    public func loadInviteCode() -> String? {
        guard
            let inviteCode: String? = userDefaults[.inviteCode]
        else { return nil }
        return inviteCode
    }
    
    
    // MARK: - Onboarding
    
    public func saveIsFirstOnboarding(_ value: Bool?) {
        userDefaults[.isFirstOnboarding] = value
    }
    
    public func loadIsFirstOnboarding() -> Bool? {
        guard let isFirstOnboarding: Bool = userDefaults[.isFirstOnboarding] else {
            return nil
        }
        return isFirstOnboarding
    }
    
    // MARK: - FamilyManagement
    
    public func saveIsFirstFamilyManagement(_ value: Bool) {
        userDefaults[.isFirstFamilyManagement] = value
    }
    
    public func loadIsFirstFamilyManagement() -> Bool {
        guard let isFirstFamilyManagement: Bool = userDefaults[.isFirstFamilyManagement] else {
            return true
        }
        
        return isFirstFamilyManagement
    }

}
