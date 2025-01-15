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
    
    
    public var dependencies: [TargetDependency] {
        switch self {
        case .Bibbi:
            return [
                .target(name: "WidgetExtension"),
                .external(name: "FirebaseMessaging"),
                .external(name: "Mixpanel"),
                .external(name: "RxDataSources"),
                .with(.Util),
                .with(.Data),
                .external(name: "ReactorKit"),
                .external(name: "Lottie"),
                .external(name: "Macros")
            ]
        case .Util:
            return [
                .external(name: "FirebaseAnalyticsWithoutAdIdSupport"),
                .external(name: "FirebaseCrashlytics"),
                .with(.Core)
            ]
        case .Data:
            return [
                .with(.Domain),
                .with(.Util),
                .external(name: "Alamofire"),
                .external(name: "KakaoSDK"),
                .external(name: "RxKakaoSDK"),
                .external(name: "Macros")
            ]
        case .Domain:
            return [
                .external(name: "RxSwift"),
                .with(.Core),
                .external(name: "Macros")
            ]
        case .Core:
            return [
                .with(.DesignSystem),
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
        }
    }
    
}
