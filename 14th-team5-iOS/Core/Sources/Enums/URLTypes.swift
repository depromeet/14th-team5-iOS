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
    case privacy
    case terms
    case inquiry
    
    public var originURL: URL {
        switch self {
        case .settings:
            return URL(string: UIApplication.openSettingsURLString) ?? URL(fileURLWithPath: "")
        case .appStore:
            return URL(string: "itms-apps://itunes.apple.com/app/6475082088") ?? URL(fileURLWithPath: "")
        case .privacy:
            return URL(string: "https://no5ing.kr/app/privacy") ?? URL(fileURLWithPath: "")
        case .terms:
            return URL(string: "https://no5ing.kr/app/terms") ?? URL(fileURLWithPath: "")
        case .inquiry:
            return URL(string: "https://forms.gle/VUsWgzNfR3ELGozP7") ?? URL(fileURLWithPath: "")
        }
    }
}
