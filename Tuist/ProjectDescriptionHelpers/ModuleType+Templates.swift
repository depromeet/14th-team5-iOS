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


public enum ModuleLayer: String, CaseIterable, ModuleType {
    
    case App
    case Data
    case Domain
    case Core
    case DesignSystem
    
    
    public var dependencies: [TargetDependency] {
        switch self {
        case .App:
            return [
                .with(.Core),
                .with(.Domain)
            ]
        case .Data:
            return [
                .with(.Domain),
                .external(name: "Alamofire"),
                .external(name: "RxSwift")
            ]
        case .Domain:
            return [
                .external(name: "ReactorKit")
            ]
        case .Core:
            return [
                .with(.DesignSystem)
            ]
        case .DesignSystem:
            return [] 
        }
    }
    
}
