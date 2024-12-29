//
//  Project.swift
//  14th-team5-iOSManifests
//
//  Created by 김도현 on 12/26/24.
//

import ProjectDescription
import ProjectDescriptionHelpers


private let targets: [Target] = [
    .makeModular(
        layer: .Util,
        factory: .init(
            products: .framework(.static),
            dependencies: ModuleLayer.Util.dependencies
        )
    )
]

private let util = Project.makeApp(name: ModuleLayer.Util.rawValue, target: targets)


