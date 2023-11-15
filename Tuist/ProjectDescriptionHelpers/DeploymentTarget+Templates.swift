//
//  DeploymentTarget+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 11/15/23.
//

import ProjectDescription

extension DeploymentTarget {
    public static let `defualt` = DeploymentTarget.iOS(targetVersion: "15.0", devices: [.iphone])
}

