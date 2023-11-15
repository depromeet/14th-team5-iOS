//
//  Workspace.swift
//  AppManifests
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projects: [Path] = ModuleLayer.allCases.map { moduleType in
    "14th-team5-iOS/\(moduleType.rawValue)"
}
let workspace = Workspace(
    name: "App",
    projects: projects
)
