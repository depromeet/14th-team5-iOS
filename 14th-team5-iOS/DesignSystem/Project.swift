//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let targets: [Target] = [
    .makeModular(
        layer: .DesignSystem,
        factory: .init(
            products: .framework(.dynamic),
            dependencies: ModuleLayer.DesignSystem.dependencies
        )
    )
]

let designSystem = Project.makeApp(name: ModuleLayer.DesignSystem.rawValue, target: targets)


