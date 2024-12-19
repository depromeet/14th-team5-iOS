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
    case stg = "STG"
    
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
                settings: ["DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"],
                xcconfig: .relativeToXCConfig(type: .dev)
            )
        case .stg:
            return .release(
                name: BuildTarget.stg.configurationName,
                settings: ["DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"],
                xcconfig: .relativeToXCConfig(type: .stg)
            )
        case .prd:
            return .release(
                name: BuildTarget.prd.configurationName,
                settings: ["DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"],
                xcconfig: .relativeToXCConfig(type: .prd)
            )
        }
    }
}
