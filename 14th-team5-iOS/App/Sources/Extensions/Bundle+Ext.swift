//
//  Bundle+Ext.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation

extension Bundle {
    internal static var current: Bundle {
        class __DUMMY__ { }
        return Bundle(for: __DUMMY__.self)
    }
}

extension Bundle {
    var appName: String {
        guard let dict = self.infoDictionary else {
            return ""
        }
        
        if let name = dict["CFBundleName"] as? String {
            return name
        } else {
            return ""
        }
    }
    
    var displayName: String {
        guard let dict = self.infoDictionary else {
            return ""
        }
        
        if let name = dict["CFBundleDisplayName"] as? String {
            return name
        } else {
            return ""
        }
        
    }
    
    var appVersion: String {
        guard let dict = self.infoDictionary else {
            return ""
        }
        
        if let version = dict["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return ""
        }
    }
    
    var appBuildNumber: Int {
        guard let dict = self.infoDictionary else {
            return 0
        }
        
        if let version = dict["CFBundleVersion"] as? String, !version.isEmpty, let number = Int(version) {
            return number
        } else {
            return 0
        }
    }
}
