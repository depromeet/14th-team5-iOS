//
//  TargetDependency+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription


public extension TargetDependency {
    static func with(_ type: ModuleLayer) -> Self {
        let moduleName = type.rawValue
        switch type {
        case .App:
            return .project(target: moduleName, path: .relativeToRoot("App/\(moduleName)"))
        case .Data:
            return .project(target: moduleName, path: .relativeToRoot("Data/\(moduleName)"))
        case .Domain:
            return .project(target: moduleName, path: .relativeToRoot("Domain/\(moduleName)"))
        case .Core:
            return .project(target: moduleName, path: .relativeToRoot("Core/\(moduleName)"))
        case .DesignSystem:
            return .project(target: moduleName, path: .relativeToRoot("DesignSystem/\(moduleName)"))
        }
    }
}
