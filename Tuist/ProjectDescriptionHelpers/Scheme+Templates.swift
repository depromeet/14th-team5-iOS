//
//  Scheme+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 11/30/23.
//

import ProjectDescription

extension Scheme {
    
    public static func makeScheme(_ type: BuildTarget, name: String) -> Self {
        let buildName = type.rawValue
        switch type {
        case .dev:
            return .scheme(
                name: "\(name)-\(buildName.uppercased())",
                buildAction: .buildAction(targets: ["\(name)"]),
                runAction: .runAction(configuration: type.configurationName) ,
                archiveAction: .archiveAction(configuration: type.configurationName),
                profileAction: .profileAction(configuration: type.configurationName),
                analyzeAction: .analyzeAction(configuration: type.configurationName)
            )
        case .prd:
            return .scheme(
                name: "\(name)-\(buildName.uppercased())",
                buildAction: .buildAction(targets: ["\(name)"]),
                runAction: .runAction(configuration: type.configurationName),
                archiveAction: .archiveAction(configuration: type.configurationName),
                profileAction: .profileAction(configuration: type.configurationName),
                analyzeAction: .analyzeAction(configuration: type.configurationName)
            )
        case .stg:
            return .scheme(
                name: "\(name)-\(buildName.uppercased())",
                buildAction: .buildAction(targets: ["\(name)"]),
                runAction: .runAction(configuration: type.configurationName),
                archiveAction: .archiveAction(configuration: type.configurationName),
                profileAction: .profileAction(configuration: type.configurationName),
                analyzeAction: .analyzeAction(configuration: type.configurationName)
            )
        }
    }
}
