//
//  ConfigurationName+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 11/30/23.
//

import ProjectDescription


public enum BuildTarget: String {
    case dev = "DEV"
    case prd = "PRD"
    
    public var configurationName: ConfigurationName {
        return ConfigurationName.configuration(self.rawValue)
    }
    
}

extension Configuration {
    public static func build(_ type: BuildTarget, name: String = "") -> Self {
        let buildName = type.rawValue
        switch type {
        case .dev:
            return .debug(
                name: BuildTarget.dev.configurationName,
                xcconfig: .relativeToXCConfig(type: .dev)
            )
        case .prd:
            return .release(
                name: BuildTarget.prd.configurationName,
                xcconfig: .relativeToXCConfig(type: .prd)
            
            )
        }
    }
}
