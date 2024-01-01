//
//  URLTypes.swift
//  Core
//
//  Created by Kim dohyun on 1/1/24.
//

import UIKit


public enum URLTypes {
    case settings
    
    public var originURL: URL {
        switch self {
        case .settings:
            return URL(string: UIApplication.openSettingsURLString) ?? URL(fileURLWithPath: "")
        }
    }
}
