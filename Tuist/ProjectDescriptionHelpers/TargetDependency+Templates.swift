//
//  TargetDependency+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription


extension TargetDependency {
    public static func with(_ type: ModuleLayer) -> Self {
        let moduleName = type.rawValue
        switch type {
        case .Bibbi:
            return .project(target: moduleName, path: .relativeToRoot("14th-team5-iOS/\(moduleName)"))
        case .Data:
            return .project(target: moduleName, path: .relativeToRoot("14th-team5-iOS/\(moduleName)"))
        case .Domain:
            return .project(target: moduleName, path: .relativeToRoot("14th-team5-iOS/\(moduleName)"))
        case .Util:
            return .project(target: moduleName, path: .relativeToRoot("14th-team5-iOS/\(moduleName)"))
        case .Core:
            return .project(target: moduleName, path: .relativeToRoot("14th-team5-iOS/\(moduleName)"))
        case .DesignSystem:
            return .project(target: moduleName, path: .relativeToRoot("14th-team5-iOS/\(moduleName)"))
        }
    }
}
