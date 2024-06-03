//
//  UserDefaults+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation

extension UserDefaults {
    
    @available(*, deprecated, message: "UserDefaultsWrpper를 사용하세요.")
    public enum Key: String, CaseIterable {
        case isFirstLaunch
        case chekcPermission
        case finishTutorial
        
        case familyId
        case memberId
        case nickname
        case postId
        case createdAt
        
        case inviteUrl
        case inviteCode
        
        case profileImage
        case snsType
        case isDefaultProfile
        
        case lastPostUploadDateId
        
        
        var value: String { "\(Bundle.current.bundleIdentifier ?? "").\(self.rawValue.lowercased())" }
    }
    
    private var userDefaults: UserDefaults {
        UserDefaults.standard
    }
}

extension UserDefaults {
    public var isFirstLaunch: Bool {
        get { UserDefaults.standard.bool(forKey: Key.isFirstLaunch.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.isFirstLaunch.value) }
    }
    public var chekcPermission: Bool {
        get { UserDefaults.standard.bool(forKey: Key.chekcPermission.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.chekcPermission.value) }
    }
    public var finishTutorial: Bool {
        get { UserDefaults.standard.bool(forKey: Key.finishTutorial.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.finishTutorial.value) }
    }
    
    public var familyId: String? {
        get { UserDefaults.standard.string(forKey: Key.familyId.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.familyId.value) }
    }
    
    public var memberId: String? {
        get { UserDefaults.standard.string(forKey: Key.memberId.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.memberId.value) }
    }
    
    public var nickname: String? {
        get { UserDefaults.standard.string(forKey: Key.nickname.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.nickname.value) }
    }
    
    public var createdAt: Date? {
        get { UserDefaults.standard.object(forKey: Key.createdAt.value) as? Date }
        set { UserDefaults.standard.set(newValue, forKey: Key.createdAt.value) }
    }
    
    public var inviteCode: String? {
        get { UserDefaults.standard.string(forKey: Key.inviteCode.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.inviteCode.value) }
    }
    
    public var inviteUrl: String? {
        get { UserDefaults.standard.string(forKey: Key.inviteUrl.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.inviteUrl.value) }
    }
    
    public var profileImage: Data? {
        get { UserDefaults.standard.data(forKey: Key.profileImage.value) }
        set { UserDefaults.standard.setValue(newValue, forKey: Key.profileImage.value)}
    }
    
    public var snsType: String? {
        get { UserDefaults.standard.string(forKey: Key.snsType.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.snsType.value) }
    }
    
    public var isDefaultProfile: Bool {
        get { UserDefaults.standard.bool(forKey: Key.isDefaultProfile.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.isDefaultProfile.value) }
    }
    
    public var postId: String? {
        get { UserDefaults.standard.string(forKey: Key.postId.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.postId.value) }
    }
}

extension UserDefaults {
    public static func isFirstLaunch() -> Bool {
        let isFirstLaunch = !Self.standard.isFirstLaunch
        if isFirstLaunch {
            Self.standard.isFirstLaunch = true
        }
        return isFirstLaunch
    }
}

extension UserDefaults {
    public func clear() {
        Key.allCases
            .map { $0.value }
            .forEach(UserDefaults.standard.removeObject)
    }
    
    public func clearInviteCode() {
        UserDefaults.standard.removeObject(forKey: Key.inviteCode.value)
    }
}
