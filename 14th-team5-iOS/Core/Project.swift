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
            dependencies: ModuleLayer.Core.dependencies,
            settings: .settings(
                base: [
                    "EXCLUDED_ARCHS[sdk=iphonesimulator*]": "arm64"
                ]
            )
        )
    )
]


private let core = Project.makeApp(name: ModuleLayer.Core.rawValue, target: targets)

