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
