//
//  URLTypes.swift
//  Core
//
//  Created by Kim dohyun on 1/1/24.
//

import UIKit


public enum URLTypes {
    case settings
    case appStore
    
    public var originURL: URL {
        switch self {
        case .settings:
            return URL(string: UIApplication.openSettingsURLString) ?? URL(fileURLWithPath: "")
        case .appStore:
            return URL(string: "itms-apps://itunes.apple.com/app/6475082088") ?? URL(fileURLWithPath: "")
        }
    }
}
