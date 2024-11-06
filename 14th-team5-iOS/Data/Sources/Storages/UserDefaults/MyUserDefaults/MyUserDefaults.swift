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
    
}

