//
//  ModuleType+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription

public protocol ModuleType {
    var dependencies: [TargetDependency] { get }
}

public enum ExtensionsLayer: String, ModuleType {
    case Widget
    
    public var dependencies: [TargetDependency] {
        switch self {
        case .Widget:
            return [
                .with(.Core),
                .with(.Domain),
                .with(.Data)
            ]
        }
    }
    
}

public enum ModuleLayer: String, CaseIterable, ModuleType {
    
    case Bibbi
    case Data
    case Domain
    case Util
    case Core
    case DesignSystem
    case ThirdPartyLibs
    
    
    public var dependencies: [TargetDependency] {
        switch self {
        case .Bibbi:
            return [
                .target(name: "WidgetExtension"),
                .sdk(name: "JavaScriptCore", type: .framework),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "RxDataSources"),
                .with(.Util),
                .with(.Data),
                .with(.ThirdPartyLibs),
                .external(name: "ReactorKit"),
                .external(name: "Lottie"),
                .external(name: "Macros")
            ]
        case .Util:
            return [
                .with(.DesignSystem),
                .with(.ThirdPartyLibs),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
            ]
        case .Data:
            return [
                .with(.Domain),
                .with(.Util),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "Alamofire"),
                .external(name: "KakaoSDK"),
                .external(name: "RxKakaoSDK"),
                .external(name: "Macros")
            ]
        case .Domain:
            return [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .with(.Core),
                .external(name: "Macros")
            ]
        case .Core:
            return [
                .with(.Util),
                .with(.DesignSystem),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "SnapKit", condition: .when(.all)),
                .external(name: "Then", condition: .when(.all)),
                .external(name: "Kingfisher", condition: .when(.all)),
                .external(name: "FSCalendar", condition: .when(.all)),
                .external(name: "RxDataSources", condition: .when(.all)),
                .external(name: "Lottie", condition: .when(.all)),
                .external(name: "Macros")
            ]
        case .DesignSystem:
            return []
        case .ThirdPartyLibs:
            return [
                .sdk(name: "JavaScriptCore", type: .framework),
                .external(name: "FirebaseAnalyticsWithoutAdIdSupport"),
                .external(name: "FirebaseCrashlytics"),
                .external(name: "FirebaseMessaging"),
                .external(name: "GoogleMobileAds", condition: .when(.all)),
            ]
        }
    }
    
}
