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

private let designSystem = Project.makeFrameWork(name: ModuleLayer.DesignSystem.rawValue, target: targets)

