//
//  UserDefaultsKey.swift
//  UserDefaultsWrapper
//
//  Created by 김건우 on 5/14/24.
//

import Foundation

public extension UserDefaultsWrapper.Key {
    
    // MARK: - App UserDefaults
    
    static let isFirstLaunchApp: Self = "isFirstLaunchApp"
    static let isFirstChangeFamilyName: Self = "isFirstChangeFamilyName"
    static let isFirstShowWidgetAlert: Self = "isFirstShowWidgetAlert"
    static let inviteCode: Self = "inviteCode"
    
    // MARK: - Family UserDefaults
    
    static let familyId: Self = "familyId"
    static let familyCreatedAt: Self = "familyCreatedAt"
    static let familyName: Self = "familyName"
    
    // MARK: - My UserDefaults
    
    static let userName: Self = "userName"
    static let memberId: Self = "memberId"
    
}
