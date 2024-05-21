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
        layer: .Core,
        factory: .init(
            products: .framework(.static),
            dependencies: ModuleLayer.Core.dependencies
        )
    )
]


private let core = Project.makeFrameWork(name: ModuleLayer.Core.rawValue, target: targets)

