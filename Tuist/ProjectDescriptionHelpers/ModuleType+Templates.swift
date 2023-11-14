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
            return []
        case .Domain:
            return [
                .with(.Data)
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
