//
//  MyUserDefaults.swift
//  Data
//
//  Created by 김건우 on 8/24/24.
//

import Core
import Foundation


public protocol MyUserDefaultsType: UserDefaultsType {
    func saveMemberId(_ memberId: String?)
    func loadMemberId() -> String?
    
    func saveUserName(_ userName: String?)
    func loadUserName() -> String?
    func saveAppVersion(_ version: String?)
    func loadAppVersion() -> String?
    func saveReviewActionCount(_ count: Int)
    func loadReviewActionCount() -> Int
    func saveLastReviewDate(_ date: Date?)
    func loadLastReviewDate() -> Date
}

final public class MyUserDefaults: MyUserDefaultsType {
    
    // MARK: - Intializer
    
    public init() { }
    
    
    // MARK: - Member Id
    
    public func saveMemberId(_ memberId: String?) {
        userDefaults[.memberId] = memberId
    }
    
    public func loadMemberId() -> String? {
        guard
            let memberId: String = userDefaults[.memberId]
        else { return nil }
        return memberId
    }
    
    
    // MARK: - UserName
    
    public func saveUserName(_ userName: String?) {
        userDefaults[.userName] = userName
    }
    
    public func loadUserName() -> String? {
        guard
            let userName: String = userDefaults[.userName]
        else { return nil }
        return userName
    }
    
    
    public func saveAppVersion(_ version: String?) {
        userDefaults[.latestVersion] = version
    }
    
    public func loadAppVersion() -> String? {
        guard let latestVersion: String = userDefaults[.latestVersion] else { return "" }
        return latestVersion
    }
    
    public func saveReviewActionCount(_ count: Int) {
        userDefaults[.reviewActionCount] = count
    }
    
    public func loadReviewActionCount() -> Int {
        guard let count: Int = userDefaults[.reviewActionCount] else { return 0 }
        return count
    }
    
    
    public func saveLastReviewDate(_ date: Date?) {
        userDefaults[.lastReviewDate] = date
    }
    
    public func loadLastReviewDate() -> Date {
        guard let lastReviewDate: Date = userDefaults[.lastReviewDate] else {
            return .now
        }
        return lastReviewDate
    }
}

