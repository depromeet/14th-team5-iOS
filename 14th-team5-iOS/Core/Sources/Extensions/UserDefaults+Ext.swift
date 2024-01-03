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
        case showTutorial
        
        case familyId
        case memberId

        var value: String { "\(Bundle.current.bundleIdentifier ?? "").\(self.rawValue.lowercased())" }
    }
}

extension UserDefaults {
    public var chekcPermission: Bool {
        get { UserDefaults.standard.bool(forKey: Key.chekcPermission.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.chekcPermission.value) }
    }
    public var showTutorial: Bool {
        get { UserDefaults.standard.bool(forKey: Key.showTutorial.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.showTutorial.value) }
    }
    
    public var familyId: String? {
        get { UserDefaults.standard.string(forKey: Key.familyId.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.familyId.value) }
    }
    
    public var memberId: String? {
        get { UserDefaults.standard.string(forKey: Key.memberId.value) }
        set { UserDefaults.standard.set(newValue, forKey: Key.memberId.value) }
    }
}

extension UserDefaults {
    public func clear() {
        Key.allCases
            .map { $0.value }
            .forEach(UserDefaults.standard.removeObject)
    }
}
