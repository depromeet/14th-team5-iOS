//
//  UserDefaults+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation

extension UserDefaults {
    public enum Key: String, CaseIterable {
        case chekcPermission
        case finishTutorial
        
        case familyId
        case memberId
        case profileImage

        var value: String { "\(Bundle.current.bundleIdentifier ?? "").\(self.rawValue.lowercased())" }
    }
}

extension UserDefaults {
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
    
    public var profileImage: Data? {
        get { UserDefaults.standard.data(forKey: Key.profileImage.value) }
        set { UserDefaults.standard.setValue(newValue, forKey: Key.profileImage.value)}
    }
}

extension UserDefaults {
    public func clear() {
        Key.allCases
            .map { $0.value }
            .forEach(UserDefaults.standard.removeObject)
    }
}
